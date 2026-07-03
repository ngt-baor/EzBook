import { supabase } from './supabaseClient'

// Helper to determine if we are connected to Supabase Cloud
const isCloudConfigured = () => {
  const url = import.meta.env.VITE_SUPABASE_URL
  const key = import.meta.env.VITE_SUPABASE_ANON_KEY
  return url && key && key !== 'YOUR_SUPABASE_ANON_KEY'
}

// LocalStorage database mock for offline fallback
const getLocalData = (key, defaultVal) => {
  const data = localStorage.getItem(key)
  if (!data) {
    localStorage.setItem(key, JSON.stringify(defaultVal))
    return defaultVal
  }
  return JSON.parse(data)
}

const setLocalData = (key, data) => {
  localStorage.setItem(key, JSON.stringify(data))
}

// Default Seed Data
const defaultAccounts = [
  { username: 'admin', mat_khau: '1', vai_tro: 'ADMIN', trang_thai: true, email: 'admin01@gmail.com', avatar: null },
  { username: 'staff01', mat_khau: '1', vai_tro: 'STAFF', trang_thai: true, email: 'staff01@gmail.com', avatar: null },
  { username: 'staff02', mat_khau: '1', vai_tro: 'STAFF', trang_thai: true, email: 'staff02@gmail.com', avatar: null },
  { username: 'staff03', mat_khau: '1', vai_tro: 'STAFF', trang_thai: true, email: 'staff03@gmail.com', avatar: null },
  { username: 'staff04', mat_khau: '1', vai_tro: 'STAFF', trang_thai: true, email: 'staff04@gmail.com', avatar: null },
  { username: '0912345678', mat_khau: '1', vai_tro: 'USER', trang_thai: true, email: 'khachhang01@gmail.com', avatar: null }
]

const defaultLoaiDichVu = [
  { id: 'L01', ten_loai: 'Chăm sóc da', mo_ta: 'Làm sạch, dưỡng da và điều trị mụn chuyên sâu' },
  { id: 'L02', ten_loai: 'Massage & Thư giãn', mo_ta: 'Massage trị liệu toàn thân, đá nóng và phục hồi cơ thể' },
  { id: 'L04', ten_loai: 'Chăm sóc & Tạo kiểu tóc', mo_ta: 'Dịch vụ cắt, gội, sấy dưỡng sinh và tạo kiểu tóc chuyên nghiệp' }
]

const defaultDichVu = [
  { id: 'DV01', loai_dich_vu_id: 'L01', ten_dich_vu: 'Chăm sóc da mặt cơ bản', gia_tien: 250000, trang_thai: true },
  { id: 'DV02', loai_dich_vu_id: 'L01', ten_dich_vu: 'Trị mụn y khoa chuyên sâu', gia_tien: 450000, trang_thai: true },
  { id: 'DV03', loai_dich_vu_id: 'L02', ten_dich_vu: 'Massage body đá nóng 60p', gia_tien: 350000, trang_thai: true },
  { id: 'DV07', loai_dich_vu_id: 'L02', ten_dich_vu: 'Gội đầu dưỡng sinh thảo dược 45p', gia_tien: 150000, trang_thai: true }
]

const defaultKhachHang = [
  { id: 'KH01', ho_ten: 'Nguyễn Văn Anh', sdt: '0912345678', ngay_sinh: '1995-05-15', username: '0912345678' }
]

const defaultNhanVien = [
  { id: 'NVADMIN', ho_ten: 'Nguyễn Thế Bảo', sdt: '0349554353', vai_tro: 'Quản trị hệ thống', trang_thai: true, username: 'admin' },
  { id: 'NV01', ho_ten: 'Phạm Minh Đức', sdt: '0933445566', vai_tro: 'Kỹ thuật viên Trưởng', trang_thai: true, username: 'staff01' },
  { id: 'NV02', ho_ten: 'Hoàng Thu Thảo', sdt: '0944556677', vai_tro: 'Nhân viên Kỹ thuật', trang_thai: true, username: 'staff02' },
  { id: 'NV03', ho_ten: 'Nguyễn Hải Yến', sdt: '0955667788', vai_tro: 'Tiếp tân', trang_thai: true, username: 'staff03' },
  { id: 'NV04', ho_ten: 'Lê Tuấn Nam', sdt: '0961000001', vai_tro: 'Nhân viên Kỹ thuật', trang_thai: true, username: 'staff04' }
]

const defaultKhuyenMai = [
  { id: 'KM01', ma_giam_gia: 'RETROSTART', loai_giam: 'Phan tram', gia_tri: 10, ngay_bat_dau: '2026-01-01', ngay_ket_thuc: '2026-12-31', so_luong_gioi_han: 100, trang_thai: true },
  { id: 'KM02', ma_giam_gia: 'EZVIP', loai_giam: 'So tien co dinh', gia_tri: 50000, ngay_bat_dau: '2026-01-01', ngay_ket_thuc: '2026-12-31', so_luong_gioi_han: 50, trang_thai: true }
]

const defaultBookings = []
const defaultHoaDons = []

export const dbService = {
  isCloud() {
    return isCloudConfigured()
  },

  // 1. TÀI KHOẢN (ACCOUNTS)
  async login(username, password) {
    if (isCloudConfigured()) {
      const { data, error } = await supabase
        .from('taikhoan')
        .select('*')
        .eq('username', username)
        .eq('mat_khau', password)
        .single()
      if (error || !data) return { error: 'invalid' }
      if (!data.trang_thai) return { error: 'locked' }
      
      // Get display name based on role
      let displayName = username
      if (data.vai_tro === 'ADMIN' || data.vai_tro === 'STAFF') {
        const { data: nv } = await supabase.from('nhanvien').select('ho_ten').eq('username', username).single()
        if (nv) displayName = nv.ho_ten
      } else {
        const { data: kh } = await supabase.from('khachhang').select('ho_ten').eq('username', username).single()
        if (kh) displayName = kh.ho_ten
      }

      return { data: { ...data, displayName } }
    } else {
      const accounts = getLocalData('taikhoan', defaultAccounts)
      const user = accounts.find(a => a.username === username && a.mat_khau === password)
      if (!user) return { error: 'invalid' }
      if (!user.trang_thai) return { error: 'locked' }
      
      let displayName = username
      if (user.vai_tro === 'ADMIN' || user.vai_tro === 'STAFF') {
        const nvs = getLocalData('nhanvien', defaultNhanVien)
        const nv = nvs.find(n => n.username === username)
        if (nv) displayName = nv.ho_ten
      } else {
        const khs = getLocalData('khachhang', defaultKhachHang)
        const kh = khs.find(k => k.username === username)
        if (kh) displayName = kh.ho_ten
      }

      return { data: { ...user, displayName } }
    }
  },

  async getAccounts() {
    if (isCloudConfigured()) {
      const { data } = await supabase.from('taikhoan').select('*').order('username')
      return data || []
    } else {
      return getLocalData('taikhoan', defaultAccounts)
    }
  },

  async createAccount(account) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('taikhoan').insert([account])
      return !error
    } else {
      const accounts = getLocalData('taikhoan', defaultAccounts)
      accounts.push(account)
      setLocalData('taikhoan', accounts)
      return true
    }
  },

  async updateAccountStatus(username, status) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('taikhoan').update({ trang_thai: status }).eq('username', username)
      return !error
    } else {
      const accounts = getLocalData('taikhoan', defaultAccounts)
      const user = accounts.find(a => a.username === username)
      if (user) user.trang_thai = status
      setLocalData('taikhoan', accounts)
      return true
    }
  },

  // 2. NHÂN VIÊN (EMPLOYEES)
  async getEmployees() {
    if (isCloudConfigured()) {
      const { data } = await supabase.from('nhanvien').select('*').order('id')
      return data || []
    } else {
      return getLocalData('nhanvien', defaultNhanVien)
    }
  },

  async createEmployee(employee) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('nhanvien').insert([employee])
      return !error
    } else {
      const list = getLocalData('nhanvien', defaultNhanVien)
      list.push(employee)
      setLocalData('nhanvien', list)
      return true
    }
  },

  async updateEmployee(employee) {
    if (isCloudConfigured()) {
      const { error } = await supabase
        .from('nhanvien')
        .update({
          ho_ten: employee.ho_ten,
          sdt: employee.sdt,
          vai_tro: employee.vai_tro,
          trang_thai: employee.trang_thai,
          username: employee.username
        })
        .eq('id', employee.id)
      return !error
    } else {
      const list = getLocalData('nhanvien', defaultNhanVien)
      const idx = list.findIndex(e => e.id === employee.id)
      if (idx !== -1) list[idx] = employee
      setLocalData('nhanvien', list)
      return true
    }
  },

  async deleteEmployee(id) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('nhanvien').delete().eq('id', id)
      return !error
    } else {
      const list = getLocalData('nhanvien', defaultNhanVien)
      const filtered = list.filter(e => e.id !== id)
      setLocalData('nhanvien', filtered)
      return true
    }
  },

  // 3. DỊCH VỤ (SERVICES)
  async getLoaiDichVu() {
    if (isCloudConfigured()) {
      const { data } = await supabase.from('loaidichvu').select('*').order('id')
      return data || []
    } else {
      return getLocalData('loaidichvu', defaultLoaiDichVu)
    }
  },

  async getServices() {
    if (isCloudConfigured()) {
      const { data } = await supabase.from('dichvu').select('*').order('id')
      return data || []
    } else {
      return getLocalData('dichvu', defaultDichVu)
    }
  },

  async createService(service) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('dichvu').insert([service])
      return !error
    } else {
      const list = getLocalData('dichvu', defaultDichVu)
      list.push(service)
      setLocalData('dichvu', list)
      return true
    }
  },

  async updateService(service) {
    if (isCloudConfigured()) {
      const { error } = await supabase
        .from('dichvu')
        .update({
          loai_dich_vu_id: service.loai_dich_vu_id,
          ten_dich_vu: service.ten_dich_vu,
          gia_tien: service.gia_tien,
          trang_thai: service.trang_thai
        })
        .eq('id', service.id)
      return !error
    } else {
      const list = getLocalData('dichvu', defaultDichVu)
      const idx = list.findIndex(s => s.id === service.id)
      if (idx !== -1) list[idx] = service
      setLocalData('dichvu', list)
      return true
    }
  },

  async deleteService(id) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('dichvu').delete().eq('id', id)
      return !error
    } else {
      const list = getLocalData('dichvu', defaultDichVu)
      const filtered = list.filter(s => s.id !== id)
      setLocalData('dichvu', filtered)
      return true
    }
  },

  // 4. KHUYẾN MÃI (PROMOTIONS)
  async getPromotions() {
    if (isCloudConfigured()) {
      const { data } = await supabase.from('khuyenmai').select('*').order('id')
      return data || []
    } else {
      return getLocalData('khuyenmai', defaultKhuyenMai)
    }
  },

  async createPromotion(promo) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('khuyenmai').insert([promo])
      return !error
    } else {
      const list = getLocalData('khuyenmai', defaultKhuyenMai)
      list.push(promo)
      setLocalData('khuyenmai', list)
      return true
    }
  },

  async updatePromotion(promo) {
    if (isCloudConfigured()) {
      const { error } = await supabase
        .from('khuyenmai')
        .update({
          ma_giam_gia: promo.ma_giam_gia,
          loai_giam: promo.loai_giam,
          gia_tri: promo.gia_tri,
          ngay_bat_dau: promo.ngay_bat_dau,
          ngay_ket_thuc: promo.ngay_ket_thuc,
          so_luong_gioi_han: promo.so_luong_gioi_han,
          trang_thai: promo.trang_thai
        })
        .eq('id', promo.id)
      return !error
    } else {
      const list = getLocalData('khuyenmai', defaultKhuyenMai)
      const idx = list.findIndex(p => p.id === promo.id)
      if (idx !== -1) list[idx] = promo
      setLocalData('khuyenmai', list)
      return true
    }
  },

  async deletePromotion(id) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('khuyenmai').delete().eq('id', id)
      return !error
    } else {
      const list = getLocalData('khuyenmai', defaultKhuyenMai)
      const filtered = list.filter(p => p.id !== id)
      setLocalData('khuyenmai', filtered)
      return true
    }
  },

  // 5. BOOKING & HÓA ĐƠN
  async getBookings() {
    if (isCloudConfigured()) {
      const { data } = await supabase
        .from('booking')
        .select(`
          *,
          khachhang:khach_hang_id (ho_ten, sdt),
          nhanvien:nhan_vien_id (ho_ten),
          dichvu:dich_vu_id (ten_dich_vu, gia_tien),
          khuyenmai:khuyen_mai_id (ma_giam_gia, loai_giam, gia_tri)
        `)
        .order('thoi_gian_hen', { ascending: false })
      return data || []
    } else {
      const bookings = getLocalData('booking', defaultBookings)
      const khs = getLocalData('khachhang', defaultKhachHang)
      const nvs = getLocalData('nhanvien', defaultNhanVien)
      const dvs = getLocalData('dichvu', defaultDichVu)
      const kms = getLocalData('khuyenmai', defaultKhuyenMai)

      return bookings.map(b => ({
        ...b,
        khachhang: khs.find(k => k.id === b.khach_hang_id) || { ho_ten: 'Không rõ', sdt: '' },
        nhanvien: nvs.find(n => n.id === b.nhan_vien_id) || null,
        dichvu: dvs.find(d => d.id === b.dich_vu_id) || { ten_dich_vu: 'Không rõ', gia_tien: 0 },
        khuyenmai: kms.find(k => k.id === b.khuyen_mai_id) || null
      }))
    }
  },

  async createBooking(booking) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('booking').insert([booking])
      return !error
    } else {
      const list = getLocalData('booking', defaultBookings)
      list.push(booking)
      setLocalData('booking', list)
      return true
    }
  },

  async updateBookingStatus(id, trangThai) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('booking').update({ trang_thai_booking: trangThai }).eq('id', id)
      
      // Auto-create invoice if completed
      if (!error && trangThai === 'Completed') {
        const { data: b } = await supabase
          .from('booking')
          .select(`
            *,
            dichvu:dich_vu_id (gia_tien),
            khuyenmai:khuyen_mai_id (loai_giam, gia_tri)
          `)
          .eq('id', id)
          .single()
        
        if (b) {
          const totalGoc = Number(b.dichvu.gia_tien)
          let giam = 0
          if (b.khuyenmai) {
            if (b.khuyenmai.loai_giam === 'Phan tram') {
              giam = (totalGoc * Number(b.khuyenmai.gia_tri)) / 100
            } else {
              giam = Number(b.khuyenmai.gia_tri)
            }
          }
          const thanhTien = Math.max(0, totalGoc - giam)
          const hdId = 'HD' + Date.now().toString().slice(-6)

          await supabase.from('hoadon').insert([{
            id: hdId,
            booking_id: id,
            tong_tien_goc: totalGoc,
            tien_giam_gia: giam,
            thanh_tien: thanhTien,
            phuong_thuc_thanh_toan: '',
            trang_thai_trang_thai: 'Chua thanh toan',
            thoi_gian_thanh_toan: null
          }])
        }
      }
      return !error
    } else {
      const list = getLocalData('booking', defaultBookings)
      const b = list.find(x => x.id === id)
      if (b) {
        b.trang_thai_booking = trangThai
        setLocalData('booking', list)

        if (trangThai === 'Completed') {
          const dvs = getLocalData('dichvu', defaultDichVu)
          const kms = getLocalData('khuyenmai', defaultKhuyenMai)
          const dv = dvs.find(x => x.id === b.dich_vu_id)
          const km = kms.find(x => x.id === b.khuyen_mai_id)

          const totalGoc = dv ? Number(dv.gia_tien) : 0
          let giam = 0
          if (km) {
            if (km.loai_giam === 'Phan tram') {
              giam = (totalGoc * Number(km.gia_tri)) / 100
            } else {
              giam = Number(km.gia_tri)
            }
          }
          const thanhTien = Math.max(0, totalGoc - giam)
          const hdId = 'HD' + Date.now().toString().slice(-6)

          const hoadons = getLocalData('hoadon', defaultHoaDons)
          hoadons.push({
            id: hdId,
            booking_id: id,
            tong_tien_goc: totalGoc,
            tien_giam_gia: giam,
            thanh_tien: thanhTien,
            phuong_thuc_thanh_toan: '',
            trang_thai_thanh_toan: 'Chua thanh toan',
            thoi_gian_thanh_toan: null
          })
          setLocalData('hoadon', hoadons)
        }
      }
      return true
    }
  },

  async getInvoices() {
    if (isCloudConfigured()) {
      const { data } = await supabase
        .from('hoadon')
        .select(`
          *,
          booking:booking_id (
            thoi_gian_hen,
            khachhang:khach_hang_id (ho_ten, sdt),
            dichvu:dich_vu_id (ten_dich_vu)
          )
        `)
        .order('id', { ascending: false })
      return data || []
    } else {
      const hoadons = getLocalData('hoadon', defaultHoaDons)
      const bookings = getLocalData('booking', defaultBookings)
      const khs = getLocalData('khachhang', defaultKhachHang)
      const dvs = getLocalData('dichvu', defaultDichVu)

      return hoadons.map(h => {
        const b = bookings.find(x => x.id === h.booking_id) || {}
        return {
          ...h,
          booking: {
            thoi_gian_hen: b.thoi_gian_hen || '',
            khachhang: khs.find(x => x.id === b.khach_hang_id) || { ho_ten: 'Không rõ', sdt: '' },
            dichvu: dvs.find(x => x.id === b.dich_vu_id) || { ten_dich_vu: 'Không rõ' }
          }
        }
      })
    }
  },

  async updateInvoiceStatus(id, trangThai, phuongThuc) {
    if (isCloudConfigured()) {
      const { error } = await supabase
        .from('hoadon')
        .update({
          trang_thai_thanh_toan: trangThai,
          phuong_thuc_thanh_toan: phuongThuc,
          thoi_gian_thanh_toan: trangThai === 'Da thanh toan' ? new Date().toISOString() : null
        })
        .eq('id', id)
      return !error
    } else {
      const list = getLocalData('hoadon', defaultHoaDons)
      const h = list.find(x => x.id === id)
      if (h) {
        h.trang_thai_thanh_toan = trangThai
        h.phuong_thuc_thanh_toan = phuongThuc
        h.thoi_gian_thanh_toan = trangThai === 'Da thanh toan' ? new Date().toISOString() : null
        setLocalData('hoadon', list)
      }
      return true
    }
  },

  // 6. KHÁCH HÀNG (CUSTOMERS)
  async getCustomers() {
    if (isCloudConfigured()) {
      const { data } = await supabase.from('khachhang').select('*')
      return data || []
    } else {
      return getLocalData('khachhang', defaultKhachHang)
    }
  },

  async createCustomer(kh) {
    if (isCloudConfigured()) {
      const { error } = await supabase.from('khachhang').insert([kh])
      return !error
    } else {
      const list = getLocalData('khachhang', defaultKhachHang)
      list.push(kh)
      setLocalData('khachhang', list)
      return true
    }
  }
}
