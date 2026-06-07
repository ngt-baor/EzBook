package com.example.ezbook.controller;

import com.example.ezbook.entity.MonthlyRevenue;
import com.example.ezbook.entity.BookingView;
import com.example.ezbook.entity.TopDichVuThongKe;
import com.example.ezbook.repository.BookingRepository;
import com.example.ezbook.repository.HoaDonRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.Year;
import java.util.List;

@WebServlet(name = "thongKeServlet", value = {"/thong-ke/hien-thi"})
public class ThongKeServlet extends HttpServlet {
    private final HoaDonRepository hoaDonRepository = new HoaDonRepository();
    private final BookingRepository bookingRepository = new BookingRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int year = parseYear(req.getParameter("year"));
        HttpSession session = req.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("role");
        String username = session == null ? null : (String) session.getAttribute("username");

        List<MonthlyRevenue> doanhThuThang = hoaDonRepository.thongKeDoanhThuTheoThang(year);

        double max = 0.0;
        double totalRevenue = 0.0;
        for (MonthlyRevenue item : doanhThuThang) {
            totalRevenue += item.getRevenue();
            if (item.getRevenue() > max) {
                max = item.getRevenue();
            }
        }

        double safeMax = max <= 0 ? 1.0 : max;
        for (MonthlyRevenue item : doanhThuThang) {
            item.setWidthPercent((item.getRevenue() / safeMax) * 100.0);
        }

        req.setAttribute("year", year);
        req.setAttribute("doanhThuThang", doanhThuThang);
        req.setAttribute("hasRevenueData", max > 0);
        req.setAttribute("maxDoanhThu", safeMax);
        req.setAttribute("totalRevenue", totalRevenue);

        List<TopDichVuThongKe> topDichVu = bookingRepository.thongKeTopDichVuDuocDatNhieu(year);
        req.setAttribute("topDichVu", topDichVu);

        List<BookingView> lichHenHomNay = bookingRepository.getLichHenHomNay(role, username);
        List<BookingView> lichHenSapDienRa = bookingRepository.getLichHenSapDienRa(role, username);
        req.setAttribute("lichHenHomNay", lichHenHomNay);
        req.setAttribute("lichHenSapDienRa", lichHenSapDienRa);
        req.setAttribute("bookingScopeLabel", "STAFF".equals(role) ? "Lich cua nhan vien dang nhap" : "Lich toan he thong");

        req.getRequestDispatcher("/thong-ke/hien-thi.jsp").forward(req, resp);
    }

    private int parseYear(String yearRaw) {
        try {
            if (yearRaw == null || yearRaw.trim().isEmpty()) {
                return Year.now().getValue();
            }
            return Integer.parseInt(yearRaw.trim());
        } catch (NumberFormatException e) {
            return Year.now().getValue();
        }
    }
}
