import React, { useState, useEffect } from 'react'
import { dbService } from './dbService'

export default function App() {
  // Authentication State
  const [currentUser, setCurrentUser] = useState(null)
  const [authTab, setAuthTab] = useState('login') // 'login' | 'register'
  
  // Registration Form
  const [regForm, setRegForm] = useState({
    username: '',
    fullname: '',
    dob: '',
    email: '',
    password: ''
  })
  
  // Login Form
  const [loginUser, setLoginUser] = useState('')
  const [loginPass, setLoginPass] = useState('')
  const [authError, setAuthError] = useState('')

  // App Navigation Tab
  const [activeTab, setActiveTab] = useState('home') // 'home' | 'employees' | 'accounts' | 'services' | 'promotions' | 'bookings' | 'invoices' | 'stats' | 'customer-booking'

  // Data States
  const [employees, setEmployees] = useState([])
  const [accounts, setAccounts] = useState([])
  const [services, setServices] = useState([])
  const [loaiDichVu, setLoaiDichVu] = useState([])
  const [promotions, setPromotions] = useState([])
  const [bookings, setBookings] = useState([])
  const [invoices, setInvoices] = useState([])

  // CRUD Forms State
  const [empForm, setEmpForm] = useState({ id: '', ho_ten: '', sdt: '', vai_tro: 'Nhân viên Kỹ thuật', trang_thai: true, username: '' })
  const [isEditingEmp, setIsEditingEmp] = useState(false)

  const [srvForm, setSrvForm] = useState({ id: '', loai_dich_vu_id: '', ten_dich_vu: '', gia_tien: '', trang_thai: true })
  const [isEditingSrv, setIsEditingSrv] = useState(false)

  const [promoForm, setPromoForm] = useState({ id: '', ma_giam_gia: '', loai_giam: 'Phan tram', gia_tri: '', ngay_bat_dau: '', ngay_ket_thuc: '', so_luong_gioi_han: '', trang_thai: true })
  const [isEditingPromo, setIsEditingPromo] = useState(false)

  // Booking Filters
  const [bookingFilter, setBookingFilter] = useState({ keyword: '', status: '', fromDate: '', toDate: '' })

  // Invoice Payment Modal State
  const [selectedInvoice, setSelectedInvoice] = useState(null)
  const [paymentMethod, setPaymentMethod] = useState('Tien mat')
  const [showPayModal, setShowPayModal] = useState(false)
  const [showDetailModal, setShowDetailModal] = useState(false)

  // Stats State
  const [statsYear, setStatsYear] = useState('2026')

  // Customer Booking Form
  const [custBookingForm, setCustBookingForm] = useState({
    dich_vu_id: '',
    nhan_vien_id: '',
    thoi_gian_hen: '',
    khuyen_mai_id: '',
    ghi_chu_khach_hang: ''
  })
  const [custBookingMessage, setCustBookingMessage] = useState('')

  // Load Initial Data
  const loadAllData = async () => {
    const [empData, accData, srvData, ldvData, promoData, bkgData, ivcData] = await Promise.all([
      dbService.getEmployees(),
      dbService.getAccounts(),
      dbService.getServices(),
      dbService.getLoaiDichVu(),
      dbService.getPromotions(),
      dbService.getBookings(),
      dbService.getInvoices()
    ])
    setEmployees(empData)
    setAccounts(accData)
    setServices(srvData)
    setLoaiDichVu(ldvData)
    setPromotions(promoData)
    setBookings(bkgData)
    setInvoices(ivcData)

    if (srvData.length > 0 && !srvForm.loai_dich_vu_id) {
      setSrvForm(prev => ({ ...prev, loai_dich_vu_id: ldvData[0]?.id || '' }))
    }
    if (srvData.length > 0 && !custBookingForm.dich_vu_id) {
      setCustBookingForm(prev => ({ ...prev, dich_vu_id: srvData[0]?.id || '' }))
    }
  }

  useEffect(() => {
    loadAllData()
  }, [])

  // Login handler
  const handleLogin = async (e) => {
    e.preventDefault()
    setAuthError('')
    if (!loginUser || !loginPass) {
      setAuthError('Vui lòng điền đầy đủ thông tin.')
      return
    }
    const res = await dbService.login(loginUser, loginPass)
    if (res.error) {
      if (res.error === 'locked') setAuthError('Tài khoản này đã bị khóa.')
      else setAuthError('Tên đăng nhập hoặc mật khẩu không chính xác.')
    } else {
      setCurrentUser(res.data)
      if (res.data.vai_tro === 'USER') {
        setActiveTab('customer-booking')
      } else {
        setActiveTab('home')
      }
      setLoginUser('')
      setLoginPass('')
    }
  }

  // Registration handler
  const handleRegister = async (e) => {
    e.preventDefault()
    setAuthError('')
    const { username, fullname, dob, email, password } = regForm
    if (!username || !fullname || !password) {
      setAuthError('Vui lòng điền các trường bắt buộc (*).')
      return
    }

    // Phone number validates as username
    const accOk = await dbService.createAccount({
      username,
      mat_khau: password,
      vai_tro: 'USER',
      trang_thai: true,
      email: email || null,
      avatar: null,
      ma_xac_nhan: null
    })

    if (accOk) {
      const khId = 'KH' + Date.now().toString().slice(-6)
      await dbService.createCustomer({
        id: khId,
        ho_ten: fullname,
        sdt: username,
        ngay_sinh: dob || null,
        username
      })
      alert('Đăng ký thành công! Hãy đăng nhập.')
      setAuthTab('login')
      setLoginUser(username)
      setLoginPass(password)
      loadAllData()
    } else {
      setAuthError('Đăng ký thất bại. Số điện thoại/Tài khoản đã tồn tại.')
    }
  }

  const handleLogout = () => {
    setCurrentUser(null)
    setActiveTab('home')
    setAuthTab('login')
    setAuthError('')
  }

  // CRUD Employee handlers
  const handleSaveEmployee = async (e) => {
    e.preventDefault()
    if (!empForm.id || !empForm.ho_ten) {
      alert('Mã NV và Họ tên không được để trống.')
      return
    }

    if (isEditingEmp) {
      const ok = await dbService.updateEmployee(empForm)
      if (ok) alert('Cập nhật nhân viên thành công!')
    } else {
      const ok = await dbService.createEmployee(empForm)
      if (ok) alert('Thêm nhân viên thành công!')
    }
    setEmpForm({ id: '', ho_ten: '', sdt: '', vai_tro: 'Nhân viên Kỹ thuật', trang_thai: true, username: '' })
    setIsEditingEmp(false)
    loadAllData()
  }

  const handleEditEmp = (emp) => {
    setEmpForm(emp)
    setIsEditingEmp(true)
  }

  const handleDeleteEmp = async (id) => {
    if (confirm('Bạn có chắc chắn muốn xóa nhân viên này?')) {
      await dbService.deleteEmployee(id)
      loadAllData()
    }
  }

  // CRUD Service handlers
  const handleSaveService = async (e) => {
    e.preventDefault()
    if (!srvForm.id || !srvForm.ten_dich_vu || !srvForm.gia_tien) {
      alert('Mã DV, Tên dịch vụ và Giá tiền không được để trống.')
      return
    }

    const payload = { ...srvForm, gia_tien: Number(srvForm.gia_tien) }
    if (isEditingSrv) {
      const ok = await dbService.updateService(payload)
      if (ok) alert('Cập nhật dịch vụ thành công!')
    } else {
      const ok = await dbService.createService(payload)
      if (ok) alert('Thêm dịch vụ thành công!')
    }
    setSrvForm({ id: '', loai_dich_vu_id: loaiDichVu[0]?.id || '', ten_dich_vu: '', gia_tien: '', trang_thai: true })
    setIsEditingSrv(false)
    loadAllData()
  }

  const handleEditSrv = (srv) => {
    setSrvForm(srv)
    setIsEditingSrv(true)
  }

  const handleDeleteSrv = async (id) => {
    if (confirm('Bạn có chắc chắn muốn xóa dịch vụ này?')) {
      await dbService.deleteService(id)
      loadAllData()
    }
  }

  // CRUD Promotion handlers
  const handleSavePromotion = async (e) => {
    e.preventDefault()
    if (!promoForm.id || !promoForm.ma_giam_gia || !promoForm.gia_tri) {
      alert('Mã KM, Mã giảm giá và Giá trị không được để trống.')
      return
    }

    const payload = {
      ...promoForm,
      gia_tri: Number(promoForm.gia_tri),
      so_luong_gioi_han: Number(promoForm.so_luong_gioi_han || 0)
    }

    if (isEditingPromo) {
      const ok = await dbService.updatePromotion(payload)
      if (ok) alert('Cập nhật khuyến mãi thành công!')
    } else {
      const ok = await dbService.createPromotion(payload)
      if (ok) alert('Thêm khuyến mãi thành công!')
    }
    setPromoForm({ id: '', ma_giam_gia: '', loai_giam: 'Phan tram', gia_tri: '', ngay_bat_dau: '', ngay_ket_thuc: '', so_luong_gioi_han: '', trang_thai: true })
    setIsEditingPromo(false)
    loadAllData()
  }

  const handleEditPromo = (promo) => {
    setPromoForm(promo)
    setIsEditingPromo(true)
  }

  const handleDeletePromo = async (id) => {
    if (confirm('Bạn có chắc chắn muốn xóa khuyến mãi này?')) {
      await dbService.deletePromotion(id)
      loadAllData()
    }
  }

  // Account Toggle Lock
  const handleToggleAccountLock = async (username, currentStatus) => {
    await dbService.updateAccountStatus(username, !currentStatus)
    loadAllData()
  }

  // Booking handlers
  const handleConfirmBooking = async (id) => {
    await dbService.updateBookingStatus(id, 'Confirmed')
    loadAllData()
  }

  const handleCompleteBooking = async (id) => {
    await dbService.updateBookingStatus(id, 'Completed')
    loadAllData()
    alert('Đã hoàn thành lịch hẹn! Hóa đơn tạm tính đã được khởi tạo tự động.')
  }

  const handleCancelBooking = async (id) => {
    if (confirm('Bạn có chắc muốn hủy lịch hẹn này?')) {
      await dbService.updateBookingStatus(id, 'Cancelled')
      loadAllData()
    }
  }

  // Invoice handlers
  const openPayModal = (invoice) => {
    setSelectedInvoice(invoice)
    setShowPayModal(true)
  }

  const handlePayInvoice = async () => {
    if (!selectedInvoice) return
    await dbService.updateInvoiceStatus(selectedInvoice.id, 'Da thanh toan', paymentMethod)
    setShowPayModal(false)
    setSelectedInvoice(null)
    loadAllData()
    alert('Thanh toán hóa đơn thành công!')
  }

  const handleCancelInvoice = async (id) => {
    if (confirm('Bạn có chắc chắn muốn hủy hóa đơn này?')) {
      await dbService.updateInvoiceStatus(id, 'Huy hoa don', '')
      loadAllData()
    }
  }

  // Customer Booking Submit
  const handleCustomerBookingSubmit = async (e) => {
    e.preventDefault()
    setCustBookingMessage('')
    if (!custBookingForm.thoi_gian_hen) {
      setCustBookingMessage('Vui lòng chọn thời gian hẹn.')
      return
    }

    // Get customer profile
    const customers = await dbService.getCustomers()
    const currentCustomer = customers.find(c => c.username === currentUser.username)
    if (!currentCustomer) {
      setCustBookingMessage('Lỗi hệ thống: Không tìm thấy hồ sơ khách hàng.')
      return
    }

    const bookingId = 'BK' + Date.now().toString().slice(-6)
    const success = await dbService.createBooking({
      id: bookingId,
      khach_hang_id: currentCustomer.id,
      nhan_vien_id: custBookingForm.nhan_vien_id || null,
      dich_vu_id: custBookingForm.dich_vu_id,
      khuyen_mai_id: custBookingForm.khuyen_mai_id || null,
      thoi_gian_hen: custBookingForm.thoi_gian_hen,
      trang_thai_booking: 'Pending',
      ghi_chu_khach_hang: custBookingForm.ghi_chu_khach_hang || null
    })

    if (success) {
      alert('Đặt lịch hẹn trực tuyến thành công!')
      setCustBookingForm(prev => ({
        ...prev,
        thoi_gian_hen: '',
        khuyen_mai_id: '',
        ghi_chu_khach_hang: ''
      }))
      loadAllData()
    } else {
      setCustBookingMessage('Có lỗi xảy ra khi đặt lịch. Vui lòng thử lại.')
    }
  }

  // Filter Bookings logic
  const filteredBookings = bookings.filter(b => {
    // Keyword filter (by customer name or phone)
    const khName = b.khachhang?.ho_ten?.toLowerCase() || ''
    const khSdt = b.khachhang?.sdt || ''
    const keywordMatch = !bookingFilter.keyword || 
                         khName.includes(bookingFilter.keyword.toLowerCase()) || 
                         khSdt.includes(bookingFilter.keyword)
    
    // Status filter
    const statusMatch = !bookingFilter.status || b.trang_thai_booking === bookingFilter.status

    // Date filter
    const bDate = b.thoi_gian_hen ? b.thoi_gian_hen.substring(0, 10) : ''
    const dateFromMatch = !bookingFilter.fromDate || bDate >= bookingFilter.fromDate
    const dateToMatch = !bookingFilter.toDate || bDate <= bookingFilter.toDate

    return keywordMatch && statusMatch && dateFromMatch && dateToMatch
  })

  // Stats calculation
  const getMonthlyRevenue = () => {
    const monthlyRev = Array(12).fill(0)
    invoices.forEach(h => {
      if (h.trang_thai_thanh_toan === 'Da thanh toan' && h.thoi_gian_thanh_toan) {
        const year = h.thoi_gian_thanh_toan.substring(0, 4)
        if (year === statsYear) {
          const month = parseInt(h.thoi_gian_thanh_toan.substring(5, 7), 10) - 1
          monthlyRev[month] += Number(h.thanh_tien)
        }
      }
    })
    return monthlyRev
  }
  const monthlyRevenueData = getMonthlyRevenue()
  const totalRevenue = monthlyRevenueData.reduce((a, b) => a + b, 0)

  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column' }}>
      {/* DB Connection Status Toast */}
      <div style={{
        background: dbService.isCloud() ? '#22c55e' : '#eab308',
        color: '#000',
        padding: '6px 12px',
        fontSize: '11px',
        fontWeight: 'bold',
        textAlign: 'center',
        letterSpacing: '0.05em'
      }}>
        {dbService.isCloud() 
          ? '🟢 CLOUD DATABASE: SUPABASE (CONNECTED)' 
          : '⚠️ OFFLINE MODE (LOCAL STORAGE) - CONFIG .ENV TO CONNECT TO SUPABASE CLOUD'}
      </div>

      {/* Main Container */}
      {!currentUser ? (
        /* ================= AUTHENTICATION SHIELD ================= */
        <main className="landing" style={{ flex: 1 }}>
          <div className="auth-shell">
            <h1 className="auth-title" style={{ fontSize: '48px', marginBottom: '8px' }}>EzBook</h1>
            <p className="auth-subtitle" style={{ marginBottom: '24px' }}>Hệ thống đặt lịch làm đẹp và chăm sóc sức khỏe phong cách Graphite.</p>

            <div className="panel" style={{ background: 'var(--surface-raised)' }}>
              <div className="panel-head" style={{ justifyContent: 'center', gap: '20px' }}>
                <button 
                  onClick={() => { setAuthTab('login'); setAuthError('') }} 
                  className={`toolbar-link ${authTab === 'login' ? 'active' : ''}`}
                  style={{ fontSize: '16px', fontWeight: 'bold' }}
                >
                  Đăng nhập
                </button>
                <button 
                  onClick={() => { setAuthTab('register'); setAuthError('') }} 
                  className={`toolbar-link ${authTab === 'register' ? 'active' : ''}`}
                  style={{ fontSize: '16px', fontWeight: 'bold' }}
                >
                  Đăng ký
                </button>
              </div>

              <div className="panel-body">
                {authError && (
                  <div style={{ background: '#fef2f2', color: '#b91c1c', border: '1px solid #fee2e2', padding: '10px', marginBottom: '14px', borderRadius: '4px', fontSize: '13px' }}>
                    {authError}
                  </div>
                )}

                {authTab === 'login' ? (
                  <form onSubmit={handleLogin}>
                    <div className="form-group">
                      <label className="form-label">Tên đăng nhập / Số điện thoại</label>
                      <input 
                        type="text" 
                        className="form-control" 
                        value={loginUser}
                        onChange={(e) => setLoginUser(e.target.value)}
                        placeholder="Nhập tên đăng nhập" 
                      />
                    </div>
                    <div className="form-group">
                      <label className="form-label">Mật khẩu</label>
                      <input 
                        type="password" 
                        className="form-control" 
                        value={loginPass}
                        onChange={(e) => setLoginPass(e.target.value)}
                        placeholder="••••••••" 
                      />
                    </div>
                    <button type="submit" className="btn btn-primary" style={{ width: '100%', marginTop: '10px' }}>
                      Đăng Nhập
                    </button>
                  </form>
                ) : (
                  <form onSubmit={handleRegister}>
                    <div className="form-group">
                      <label className="form-label">Số điện thoại (dùng đăng nhập) *</label>
                      <input 
                        type="tel" 
                        className="form-control" 
                        value={regForm.username}
                        onChange={(e) => setRegForm({...regForm, username: e.target.value})}
                        placeholder="Ví dụ: 0912345678" 
                      />
                    </div>
                    <div className="form-group">
                      <label className="form-label">Họ và tên *</label>
                      <input 
                        type="text" 
                        className="form-control" 
                        value={regForm.fullname}
                        onChange={(e) => setRegForm({...regForm, fullname: e.target.value})}
                        placeholder="Nhập họ và tên" 
                      />
                    </div>
                    <div className="form-group">
                      <label className="form-label">Ngày sinh</label>
                      <input 
                        type="date" 
                        className="form-control" 
                        value={regForm.dob}
                        onChange={(e) => setRegForm({...regForm, dob: e.target.value})}
                      />
                    </div>
                    <div className="form-group">
                      <label className="form-label">Email liên hệ</label>
                      <input 
                        type="email" 
                        className="form-control" 
                        value={regForm.email}
                        onChange={(e) => setRegForm({...regForm, email: e.target.value})}
                        placeholder="ten@viethu.com" 
                      />
                    </div>
                    <div className="form-group">
                      <label className="form-label">Mật khẩu tài khoản *</label>
                      <input 
                        type="password" 
                        className="form-control" 
                        value={regForm.password}
                        onChange={(e) => setRegForm({...regForm, password: e.target.value})}
                        placeholder="Nhập mật khẩu" 
                      />
                    </div>
                    <button type="submit" className="btn btn-primary" style={{ width: '100%', marginTop: '10px' }}>
                      Đăng Ký Tài Khoản
                    </button>
                  </form>
                )}

                <div className="auth-links" style={{ marginTop: '20px', fontSize: '12px', textAlign: 'center', borderTop: '1px solid var(--line)', paddingTop: '15px' }}>
                  Tài khoản dùng thử: <strong style={{ color: 'var(--accent)' }}>admin</strong> / <strong style={{ color: 'var(--accent)' }}>1</strong> (ADMIN) hoặc <strong style={{ color: 'var(--accent)' }}>staff01</strong> / <strong style={{ color: 'var(--accent)' }}>1</strong> (STAFF).
                </div>
              </div>
            </div>
          </div>
        </main>
      ) : (
        /* ================= MAIN APP SHELL ================= */
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
          {/* Header */}
          <header className="page-header" style={{ borderBottom: '1px solid var(--line)' }}>
            <div className="page-heading">
              <span className="eyebrow" style={{ color: 'var(--accent)', fontWeight: 'bold' }}>EZBOOK WORKSPACE</span>
              <h1 className="page-title" style={{ margin: 0 }}>Hệ Thống Đặt Lịch Hẹn</h1>
            </div>
            <div className="toolbar" style={{ display: 'flex', alignItems: 'center', gap: '15px' }}>
              <span className="status-chip admin" style={{ fontSize: '13px', background: 'var(--surface-raised)', border: '1px solid var(--line)' }}>
                {currentUser.vai_tro}: {currentUser.displayName}
              </span>
              <button onClick={handleLogout} className="btn" style={{ padding: '6px 12px', fontSize: '12px', background: '#ef4444', color: '#fff', border: 'none' }}>
                Đăng xuất
              </button>
            </div>
          </header>

          {/* Navigation for Admin/Staff */}
          {currentUser.vai_tro !== 'USER' && (
            <div className="toolbar" style={{ background: 'var(--surface)', padding: '10px 20px', borderBottom: '1px solid var(--line)', overflowX: 'auto', display: 'flex', gap: '10px' }}>
              <button onClick={() => setActiveTab('home')} className={`toolbar-link ${activeTab === 'home' ? 'active' : ''}`}>Trang Chủ</button>
              <button onClick={() => setActiveTab('employees')} className={`toolbar-link ${activeTab === 'employees' ? 'active' : ''}`}>Nhân viên</button>
              {currentUser.vai_tro === 'ADMIN' && (
                <button onClick={() => setActiveTab('accounts')} className={`toolbar-link ${activeTab === 'accounts' ? 'active' : ''}`}>Tài khoản</button>
              )}
              <button onClick={() => setActiveTab('services')} className={`toolbar-link ${activeTab === 'services' ? 'active' : ''}`}>Dịch vụ</button>
              <button onClick={() => setActiveTab('promotions')} className={`toolbar-link ${activeTab === 'promotions' ? 'active' : ''}`}>Khuyến mãi</button>
              <button onClick={() => setActiveTab('bookings')} className={`toolbar-link ${activeTab === 'bookings' ? 'active' : ''}`}>Booking</button>
              <button onClick={() => setActiveTab('invoices')} className={`toolbar-link ${activeTab === 'invoices' ? 'active' : ''}`}>Hóa đơn</button>
              <button onClick={() => setActiveTab('stats')} className={`toolbar-link ${activeTab === 'stats' ? 'active' : ''}`}>Thống kê</button>
            </div>
          )}

          {/* Tab Contents */}
          <div style={{ flex: 1, padding: '24px' }}>
            
            {/* 1. TRANG CHỦ DASHBOARD (ADMIN & STAFF) */}
            {activeTab === 'home' && currentUser.vai_tro !== 'USER' && (
              <div>
                <h2 style={{ fontSize: '32px', marginBottom: '8px' }}>Bảng Điều Khiển</h2>
                <p style={{ color: 'var(--muted)', marginBottom: '24px' }}>Chào mừng trở lại! Vui lòng chọn một tác vụ quản trị dưới đây.</p>
                
                <div className="action-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))', gap: '20px' }}>
                  <div onClick={() => setActiveTab('employees')} className="action-card" style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column' }}>
                    <strong>Quản Lý Nhân Viên</strong>
                    <span>Thêm, sửa, xóa nhân viên và theo dõi trạng thái làm việc.</span>
                    <em>Truy cập →</em>
                  </div>
                  {currentUser.vai_tro === 'ADMIN' && (
                    <div onClick={() => setActiveTab('accounts')} className="action-card" style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column' }}>
                      <strong>Quản Lý Tài Khoản</strong>
                      <span>Kích hoạt, khóa tài khoản người dùng và thiết lập phân quyền.</span>
                      <em>Truy cập →</em>
                    </div>
                  )}
                  <div onClick={() => setActiveTab('services')} className="action-card" style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column' }}>
                    <strong>Quản Lý Dịch Vụ</strong>
                    <span>Thiết lập bảng giá dịch vụ và phân loại danh mục dịch vụ.</span>
                    <em>Truy cập →</em>
                  </div>
                  <div onClick={() => setActiveTab('promotions')} className="action-card" style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column' }}>
                    <strong>Quản Lý Khuyến Mãi</strong>
                    <span>Tạo các sự kiện giảm giá theo phần trăm hoặc số tiền cố định.</span>
                    <em>Truy cập →</em>
                  </div>
                  <div onClick={() => setActiveTab('bookings')} className="action-card" style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column' }}>
                    <strong>Quản Lý Booking</strong>
                    <span>Duyệt yêu cầu đặt lịch hẹn mới, theo dõi lịch trình của kỹ thuật viên.</span>
                    <em>Truy cập →</em>
                  </div>
                  <div onClick={() => setActiveTab('invoices')} className="action-card" style={{ cursor: 'pointer', display: 'flex', flexDirection: 'column' }}>
                    <strong>Quản Lý Hóa Đơn</strong>
                    <span>Xử lý thu tiền, cập nhật phương thức thanh toán và xuất biên lai.</span>
                    <em>Truy cập →</em>
                  </div>
                </div>
              </div>
            )}

            {/* 2. QUẢN LÝ NHÂN VIÊN */}
            {activeTab === 'employees' && (
              <div className="workspace-grid two-col" style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '24px' }}>
                {/* Form Add/Edit */}
                <div className="panel">
                  <div className="panel-head">
                    <h3>{isEditingEmp ? 'Cập Nhật Nhân Viên' : 'Thêm Nhân Viên Mới'}</h3>
                  </div>
                  <div className="panel-body">
                    <form onSubmit={handleSaveEmployee}>
                      <div className="form-group">
                        <label className="form-label">Mã nhân viên (ID) *</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          disabled={isEditingEmp}
                          value={empForm.id}
                          onChange={(e) => setEmpForm({...empForm, id: e.target.value})}
                          placeholder="Ví dụ: NV05" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Họ và tên *</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          value={empForm.ho_ten}
                          onChange={(e) => setEmpForm({...empForm, ho_ten: e.target.value})}
                          placeholder="Nguyễn Văn A" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Số điện thoại</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          value={empForm.sdt}
                          onChange={(e) => setEmpForm({...empForm, sdt: e.target.value})}
                          placeholder="09xx..." 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Vai trò công việc</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          value={empForm.vai_tro}
                          onChange={(e) => setEmpForm({...empForm, vai_tro: e.target.value})}
                          placeholder="Nhân viên Kỹ thuật, Tiếp tân..." 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Tài khoản liên kết (Username)</label>
                        <select 
                          className="form-control"
                          value={empForm.username}
                          onChange={(e) => setEmpForm({...empForm, username: e.target.value})}
                        >
                          <option value="">Không liên kết</option>
                          {accounts.filter(a => a.vai_tro === 'STAFF' || a.vai_tro === 'ADMIN').map(a => (
                            <option key={a.username} value={a.username}>{a.username} ({a.vai_tro})</option>
                          ))}
                        </select>
                      </div>
                      <div className="form-group">
                        <label className="form-label">Trạng thái làm việc</label>
                        <div style={{ display: 'flex', gap: '15px' }}>
                          <label style={{ display: 'inline-flex', alignItems: 'center', gap: '5px' }}>
                            <input 
                              type="radio" 
                              name="emp_status" 
                              checked={empForm.trang_thai === true}
                              onChange={() => setEmpForm({...empForm, trang_thai: true})}
                            /> Đang làm việc
                          </label>
                          <label style={{ display: 'inline-flex', alignItems: 'center', gap: '5px' }}>
                            <input 
                              type="radio" 
                              name="emp_status" 
                              checked={empForm.trang_thai === false}
                              onChange={() => setEmpForm({...empForm, trang_thai: false})}
                            /> Tạm nghỉ
                          </label>
                        </div>
                      </div>
                      <div style={{ display: 'flex', gap: '10px', marginTop: '15px' }}>
                        <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>Lưu lại</button>
                        {isEditingEmp && (
                          <button 
                            type="button" 
                            className="btn" 
                            style={{ background: '#6b7280', color: '#fff' }}
                            onClick={() => {
                              setIsEditingEmp(false)
                              setEmpForm({ id: '', ho_ten: '', sdt: '', vai_tro: 'Nhân viên Kỹ thuật', trang_thai: true, username: '' })
                            }}
                          >
                            Hủy
                          </button>
                        )}
                      </div>
                    </form>
                  </div>
                </div>

                {/* List Table */}
                <div className="panel">
                  <div className="panel-head" style={{ justifyContent: 'space-between' }}>
                    <h3>Danh Sách Nhân Viên</h3>
                    <span className="badge">{employees.length} Nhân viên</span>
                  </div>
                  <div className="panel-body" style={{ overflowX: 'auto' }}>
                    <table className="data-table">
                      <thead>
                        <tr>
                          <th>Mã NV</th>
                          <th>Họ và tên</th>
                          <th>Số điện thoại</th>
                          <th>Vai trò</th>
                          <th>Trạng thái</th>
                          <th>Hành động</th>
                        </tr>
                      </thead>
                      <tbody>
                        {employees.map(emp => (
                          <tr key={emp.id}>
                            <td><strong>{emp.id}</strong></td>
                            <td>{emp.ho_ten}</td>
                            <td>{emp.sdt || '—'}</td>
                            <td>{emp.vai_tro}</td>
                            <td>
                              <span className={`status-chip ${emp.trang_thai ? 'completed' : 'cancelled'}`}>
                                {emp.trang_thai ? 'Đang làm việc' : 'Tạm nghỉ'}
                              </span>
                            </td>
                            <td>
                              <div style={{ display: 'flex', gap: '5px' }}>
                                <button onClick={() => handleEditEmp(emp)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#3b82f6', color: '#fff' }}>Sửa</button>
                                <button onClick={() => handleDeleteEmp(emp.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#ef4444', color: '#fff' }}>Xóa</button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}

            {/* 3. QUẢN LÝ TÀI KHOẢN */}
            {activeTab === 'accounts' && currentUser.vai_tro === 'ADMIN' && (
              <div className="panel">
                <div className="panel-head" style={{ justifyContent: 'space-between' }}>
                  <h3>Quản Lý Tài Khoản Khách Hàng & Nhân Viên</h3>
                  <span className="badge">{accounts.length} Tài khoản</span>
                </div>
                <div className="panel-body" style={{ overflowX: 'auto' }}>
                  <table className="data-table">
                    <thead>
                      <tr>
                        <th>Username</th>
                        <th>Vai trò</th>
                        <th>Email</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      {accounts.map(acc => (
                        <tr key={acc.username}>
                          <td><strong>{acc.username}</strong></td>
                          <td>
                            <span className={`status-chip ${acc.vai_tro === 'ADMIN' ? 'admin' : acc.vai_tro === 'STAFF' ? 'staff' : 'user'}`}>
                              {acc.vai_role || acc.vai_tro}
                            </span>
                          </td>
                          <td>{acc.email || '—'}</td>
                          <td>
                            <span className={`status-chip ${acc.trang_thai ? 'completed' : 'cancelled'}`}>
                              {acc.trang_thai ? 'Hoạt động' : 'Đã khóa'}
                            </span>
                          </td>
                          <td>
                            <button 
                              onClick={() => handleToggleAccountLock(acc.username, acc.trang_thai)} 
                              className="btn" 
                              style={{ 
                                padding: '4px 10px', 
                                fontSize: '11px', 
                                background: acc.trang_thai ? '#ef4444' : '#22c55e', 
                                color: '#fff' 
                              }}
                            >
                              {acc.trang_thai ? 'Khóa tài khoản' : 'Mở khóa'}
                            </button>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* 4. QUẢN LÝ DỊCH VỤ */}
            {activeTab === 'services' && (
              <div className="workspace-grid two-col" style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '24px' }}>
                {/* Form Add/Edit */}
                <div className="panel">
                  <div className="panel-head">
                    <h3>{isEditingSrv ? 'Cập Nhật Dịch Vụ' : 'Thêm Dịch Vụ Mới'}</h3>
                  </div>
                  <div className="panel-body">
                    <form onSubmit={handleSaveService}>
                      <div className="form-group">
                        <label className="form-label">Mã dịch vụ *</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          disabled={isEditingSrv}
                          value={srvForm.id}
                          onChange={(e) => setSrvForm({...srvForm, id: e.target.value})}
                          placeholder="Ví dụ: DV08" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Nhóm loại dịch vụ *</label>
                        <select 
                          className="form-control"
                          value={srvForm.loai_dich_vu_id}
                          onChange={(e) => setSrvForm({...srvForm, loai_dich_vu_id: e.target.value})}
                        >
                          {loaiDichVu.map(ldv => (
                            <option key={ldv.id} value={ldv.id}>{ldv.ten_loai}</option>
                          ))}
                        </select>
                      </div>
                      <div className="form-group">
                        <label className="form-label">Tên dịch vụ *</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          value={srvForm.ten_dich_vu}
                          onChange={(e) => setSrvForm({...srvForm, ten_dich_vu: e.target.value})}
                          placeholder="Ví dụ: Cắt sấy gội đầu" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Đơn giá (VND) *</label>
                        <input 
                          type="number" 
                          className="form-control" 
                          value={srvForm.gia_tien}
                          onChange={(e) => setSrvForm({...srvForm, gia_tien: e.target.value})}
                          placeholder="Ví dụ: 150000" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Trạng thái phục vụ</label>
                        <div style={{ display: 'flex', gap: '15px' }}>
                          <label style={{ display: 'inline-flex', alignItems: 'center', gap: '5px' }}>
                            <input 
                              type="radio" 
                              name="srv_status" 
                              checked={srvForm.trang_thai === true}
                              onChange={() => setSrvForm({...srvForm, trang_thai: true})}
                            /> Đang cung cấp
                          </label>
                          <label style={{ display: 'inline-flex', alignItems: 'center', gap: '5px' }}>
                            <input 
                              type="radio" 
                              name="srv_status" 
                              checked={srvForm.trang_thai === false}
                              onChange={() => setSrvForm({...srvForm, trang_thai: false})}
                            /> Tạm ngưng
                          </label>
                        </div>
                      </div>
                      <div style={{ display: 'flex', gap: '10px', marginTop: '15px' }}>
                        <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>Lưu lại</button>
                        {isEditingSrv && (
                          <button 
                            type="button" 
                            className="btn" 
                            style={{ background: '#6b7280', color: '#fff' }}
                            onClick={() => {
                              setIsEditingSrv(false)
                              setSrvForm({ id: '', loai_dich_vu_id: loaiDichVu[0]?.id || '', ten_dich_vu: '', gia_tien: '', trang_thai: true })
                            }}
                          >
                            Hủy
                          </button>
                        )}
                      </div>
                    </form>
                  </div>
                </div>

                {/* List Table */}
                <div className="panel">
                  <div className="panel-head" style={{ justifyContent: 'space-between' }}>
                    <h3>Danh Sách Dịch Vụ</h3>
                    <span className="badge">{services.length} Dịch vụ</span>
                  </div>
                  <div className="panel-body" style={{ overflowX: 'auto' }}>
                    <table className="data-table">
                      <thead>
                        <tr>
                          <th>Mã DV</th>
                          <th>Tên dịch vụ</th>
                          <th>Đơn giá</th>
                          <th>Nhóm loại</th>
                          <th>Trạng thái</th>
                          <th>Hành động</th>
                        </tr>
                      </thead>
                      <tbody>
                        {services.map(srv => (
                          <tr key={srv.id}>
                            <td><strong>{srv.id}</strong></td>
                            <td>{srv.ten_dich_vu}</td>
                            <td><strong>{Number(srv.gia_tien).toLocaleString('vi-VN')} VND</strong></td>
                            <td>{loaiDichVu.find(l => l.id === srv.loai_dich_vu_id)?.ten_loai || srv.loai_dich_vu_id}</td>
                            <td>
                              <span className={`status-chip ${srv.trang_thai ? 'completed' : 'cancelled'}`}>
                                {srv.trang_thai ? 'Đang phục vụ' : 'Tạm ngưng'}
                              </span>
                            </td>
                            <td>
                              <div style={{ display: 'flex', gap: '5px' }}>
                                <button onClick={() => handleEditSrv(srv)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#3b82f6', color: '#fff' }}>Sửa</button>
                                <button onClick={() => handleDeleteSrv(srv.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#ef4444', color: '#fff' }}>Xóa</button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}

            {/* 5. QUẢN LÝ KHUYẾN MÃI */}
            {activeTab === 'promotions' && (
              <div className="workspace-grid two-col" style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '24px' }}>
                {/* Form Add/Edit */}
                <div className="panel">
                  <div className="panel-head">
                    <h3>{isEditingPromo ? 'Cập Nhật Khuyến Mãi' : 'Tạo Khuyến Mãi Mới'}</h3>
                  </div>
                  <div className="panel-body">
                    <form onSubmit={handleSavePromotion}>
                      <div className="form-group">
                        <label className="form-label">Mã khuyến mãi (ID) *</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          disabled={isEditingPromo}
                          value={promoForm.id}
                          onChange={(e) => setPromoForm({...promoForm, id: e.target.value})}
                          placeholder="Ví dụ: KM03" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Mã giảm giá (Code) *</label>
                        <input 
                          type="text" 
                          className="form-control" 
                          value={promoForm.ma_giam_gia}
                          onChange={(e) => setPromoForm({...promoForm, ma_giam_gia: e.target.value.toUpperCase()})}
                          placeholder="Ví dụ: EZSUMMER" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Loại hình giảm giá</label>
                        <select 
                          className="form-control"
                          value={promoForm.loai_giam}
                          onChange={(e) => setPromoForm({...promoForm, loai_giam: e.target.value})}
                        >
                          <option value="Phan tram">Phần trăm (%)</option>
                          <option value="So tien co dinh">Số tiền cố định (VND)</option>
                        </select>
                      </div>
                      <div className="form-group">
                        <label className="form-label">Giá trị giảm *</label>
                        <input 
                          type="number" 
                          className="form-control" 
                          value={promoForm.gia_tri}
                          onChange={(e) => setPromoForm({...promoForm, gia_tri: e.target.value})}
                          placeholder="Ví dụ: 10 hoặc 50000" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Thời gian hiệu lực</label>
                        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px' }}>
                          <input 
                            type="date" 
                            className="form-control" 
                            value={promoForm.ngay_bat_dau ? promoForm.ngay_bat_dau.substring(0,10) : ''}
                            onChange={(e) => setPromoForm({...promoForm, ngay_bat_dau: e.target.value})}
                          />
                          <input 
                            type="date" 
                            className="form-control" 
                            value={promoForm.ngay_ket_thuc ? promoForm.ngay_ket_thuc.substring(0,10) : ''}
                            onChange={(e) => setPromoForm({...promoForm, ngay_ket_thuc: e.target.value})}
                          />
                        </div>
                      </div>
                      <div className="form-group">
                        <label className="form-label">Số lượng giới hạn lượt dùng</label>
                        <input 
                          type="number" 
                          className="form-control" 
                          value={promoForm.so_luong_gioi_han}
                          onChange={(e) => setPromoForm({...promoForm, so_luong_gioi_han: e.target.value})}
                          placeholder="Ví dụ: 100" 
                        />
                      </div>
                      <div className="form-group">
                        <label className="form-label">Trạng thái kích hoạt</label>
                        <div style={{ display: 'flex', gap: '15px' }}>
                          <label style={{ display: 'inline-flex', alignItems: 'center', gap: '5px' }}>
                            <input 
                              type="radio" 
                              name="promo_status" 
                              checked={promoForm.trang_thai === true}
                              onChange={() => setPromoForm({...promoForm, trang_thai: true})}
                            /> Kích hoạt
                          </label>
                          <label style={{ display: 'inline-flex', alignItems: 'center', gap: '5px' }}>
                            <input 
                              type="radio" 
                              name="promo_status" 
                              checked={promoForm.trang_thai === false}
                              onChange={() => setPromoForm({...promoForm, trang_thai: false})}
                            /> Khóa mã
                          </label>
                        </div>
                      </div>
                      <div style={{ display: 'flex', gap: '10px', marginTop: '15px' }}>
                        <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>Lưu lại</button>
                        {isEditingPromo && (
                          <button 
                            type="button" 
                            className="btn" 
                            style={{ background: '#6b7280', color: '#fff' }}
                            onClick={() => {
                              setIsEditingPromo(false)
                              setPromoForm({ id: '', ma_giam_gia: '', loai_giam: 'Phan tram', gia_tri: '', ngay_bat_dau: '', ngay_ket_thuc: '', so_luong_gioi_han: '', trang_thai: true })
                            }}
                          >
                            Hủy
                          </button>
                        )}
                      </div>
                    </form>
                  </div>
                </div>

                {/* List Table */}
                <div className="panel">
                  <div className="panel-head" style={{ justifyContent: 'space-between' }}>
                    <h3>Mã Giảm Giá Khuyến Mãi</h3>
                    <span className="badge">{promotions.length} Khuyến mãi</span>
                  </div>
                  <div className="panel-body" style={{ overflowX: 'auto' }}>
                    <table className="data-table">
                      <thead>
                        <tr>
                          <th>Mã KM</th>
                          <th>Mã code</th>
                          <th>Loại giảm</th>
                          <th>Giá trị</th>
                          <th>Hiệu lực</th>
                          <th>Trạng thái</th>
                          <th>Hành động</th>
                        </tr>
                      </thead>
                      <tbody>
                        {promotions.map(promo => (
                          <tr key={promo.id}>
                            <td><strong>{promo.id}</strong></td>
                            <td><strong style={{ color: 'var(--accent)' }}>{promo.ma_giam_gia}</strong></td>
                            <td>{promo.loai_giam === 'Phan tram' ? 'Phần trăm' : 'Số tiền cố định'}</td>
                            <td>
                              <strong>
                                {promo.loai_giam === 'Phan tram' 
                                  ? `${promo.gia_tri}%` 
                                  : `${Number(promo.gia_tri).toLocaleString('vi-VN')} VND`}
                              </strong>
                            </td>
                            <td>
                              <span style={{ fontSize: '11px', display: 'block' }}>BD: {promo.ngay_bat_dau ? promo.ngay_bat_dau.substring(0, 10) : ''}</span>
                              <span style={{ fontSize: '11px', display: 'block' }}>KT: {promo.ngay_ket_thuc ? promo.ngay_ket_thuc.substring(0, 10) : ''}</span>
                            </td>
                            <td>
                              <span className={`status-chip ${promo.trang_thai ? 'completed' : 'cancelled'}`}>
                                {promo.trang_thai ? 'Hoạt động' : 'Hết hạn/Khóa'}
                              </span>
                            </td>
                            <td>
                              <div style={{ display: 'flex', gap: '5px' }}>
                                <button onClick={() => handleEditPromo(promo)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#3b82f6', color: '#fff' }}>Sửa</button>
                                <button onClick={() => handleDeletePromo(promo.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#ef4444', color: '#fff' }}>Xóa</button>
                              </div>
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            )}

            {/* 6. QUẢN LÝ BOOKING */}
            {activeTab === 'bookings' && (
              <div className="panel">
                <div className="panel-head" style={{ flexDirection: 'column', alignItems: 'stretch', gap: '15px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <h3>Quản Lý Lịch Đặt Hẹn (Booking)</h3>
                    <span className="badge">{filteredBookings.length} Lịch đặt</span>
                  </div>
                  
                  {/* Filters bar */}
                  <div className="form-grid four-col" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(180px, 1fr))', gap: '12px' }}>
                    <div className="form-group" style={{ marginBottom: 0 }}>
                      <label className="form-label">Từ khóa tìm kiếm</label>
                      <input 
                        type="text" 
                        className="form-control" 
                        value={bookingFilter.keyword}
                        onChange={(e) => setBookingFilter({...bookingFilter, keyword: e.target.value})}
                        placeholder="Tìm tên KH, SĐT..." 
                      />
                    </div>
                    <div className="form-group" style={{ marginBottom: 0 }}>
                      <label className="form-label">Bộ lọc trạng thái</label>
                      <select 
                        className="form-control"
                        value={bookingFilter.status}
                        onChange={(e) => setBookingFilter({...bookingFilter, status: e.target.value})}
                      >
                        <option value="">Tất cả trạng thái</option>
                        <option value="Pending">Chờ duyệt (Pending)</option>
                        <option value="Confirmed">Đã duyệt (Confirmed)</option>
                        <option value="Completed">Hoàn thành (Completed)</option>
                        <option value="Cancelled">Đã hủy (Cancelled)</option>
                      </select>
                    </div>
                    <div className="form-group" style={{ marginBottom: 0 }}>
                      <label className="form-label">Từ ngày</label>
                      <input 
                        type="date" 
                        className="form-control" 
                        value={bookingFilter.fromDate}
                        onChange={(e) => setBookingFilter({...bookingFilter, fromDate: e.target.value})}
                      />
                    </div>
                    <div className="form-group" style={{ marginBottom: 0 }}>
                      <label className="form-label">Đến ngày</label>
                      <input 
                        type="date" 
                        className="form-control" 
                        value={bookingFilter.toDate}
                        onChange={(e) => setBookingFilter({...bookingFilter, toDate: e.target.value})}
                      />
                    </div>
                  </div>
                </div>

                <div className="panel-body" style={{ overflowX: 'auto' }}>
                  <table className="data-table">
                    <thead>
                      <tr>
                        <th>Mã Booking</th>
                        <th>Khách hàng</th>
                        <th>Số điện thoại</th>
                        <th>Dịch vụ</th>
                        <th>Kỹ thuật viên</th>
                        <th>Thời gian hẹn</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      {filteredBookings.map(b => (
                        <tr key={b.id}>
                          <td><strong>{b.id}</strong></td>
                          <td><strong>{b.khachhang?.ho_ten}</strong></td>
                          <td>{b.khachhang?.sdt}</td>
                          <td>{b.dichvu?.ten_dich_vu}</td>
                          <td>{b.nhanvien?.ho_ten || <span style={{ color: 'var(--muted)' }}>Chưa chỉ định</span>}</td>
                          <td>
                            <strong>
                              {b.thoi_gian_hen ? b.thoi_gian_hen.replace('T', ' ').substring(0, 16) : ''}
                            </strong>
                          </td>
                          <td>
                            <span className={`status-chip ${b.trang_thai_booking.toLowerCase()}`}>
                              {b.trang_thai_booking === 'Pending' ? 'Chờ duyệt' :
                               b.trang_thai_booking === 'Confirmed' ? 'Đã duyệt' :
                               b.trang_thai_booking === 'Completed' ? 'Hoàn thành' : 'Đã hủy'}
                            </span>
                          </td>
                          <td>
                            <div style={{ display: 'flex', gap: '5px' }}>
                              {b.trang_thai_booking === 'Pending' && (
                                <button onClick={() => handleConfirmBooking(b.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#3b82f6', color: '#fff' }}>Duyệt</button>
                              )}
                              {b.trang_thai_booking === 'Confirmed' && (
                                <button onClick={() => handleCompleteBooking(b.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#22c55e', color: '#fff' }}>Xong</button>
                              )}
                              {(b.trang_thai_booking === 'Pending' || b.trang_thai_booking === 'Confirmed') && (
                                <button onClick={() => handleCancelBooking(b.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#ef4444', color: '#fff' }}>Hủy lịch</button>
                              )}
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* 7. QUẢN LÝ HÓA ĐƠN */}
            {activeTab === 'invoices' && (
              <div className="panel">
                <div className="panel-head" style={{ justifyContent: 'space-between' }}>
                  <h3>Danh Sách Hóa Đơn Doanh Thu</h3>
                  <span className="badge">{invoices.length} Hóa đơn</span>
                </div>
                <div className="panel-body" style={{ overflowX: 'auto' }}>
                  <table className="data-table">
                    <thead>
                      <tr>
                        <th>Mã HĐ</th>
                        <th>Tên khách hàng</th>
                        <th>Điện thoại</th>
                        <th>Dịch vụ</th>
                        <th>Thành tiền</th>
                        <th>Phương thức</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                      </tr>
                    </thead>
                    <tbody>
                      {invoices.map(h => (
                        <tr key={h.id}>
                          <td><strong>{h.id}</strong></td>
                          <td>{h.booking?.khachhang?.ho_ten}</td>
                          <td>{h.booking?.khachhang?.sdt}</td>
                          <td>{h.booking?.dichvu?.ten_dich_vu}</td>
                          <td><strong style={{ color: 'var(--accent)' }}>{Number(h.thanh_tien).toLocaleString('vi-VN')} VND</strong></td>
                          <td>{h.phuong_thuc_thanh_toan || '—'}</td>
                          <td>
                            <span className={`status-chip ${
                              h.trang_thai_thanh_toan === 'Da thanh toan' ? 'completed' :
                              h.trang_thai_thanh_toan === 'Huy hoa don' ? 'cancelled' : 'pending'
                            }`}>
                              {h.trang_thai_thanh_toan === 'Da thanh toan' ? 'Đã thanh toán' :
                               h.trang_thai_thanh_toan === 'Huy hoa don' ? 'Hủy hóa đơn' : 'Chưa thanh toán'}
                            </span>
                          </td>
                          <td>
                            <div style={{ display: 'flex', gap: '5px' }}>
                              {h.trang_thai_thanh_toan === 'Chua thanh toan' && (
                                <button onClick={() => openPayModal(h)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#22c55e', color: '#fff' }}>Thu tiền</button>
                              )}
                              {h.trang_thai_thanh_toan === 'Chua thanh toan' && (
                                <button onClick={() => handleCancelInvoice(h.id)} className="btn" style={{ padding: '4px 8px', fontSize: '11px', background: '#ef4444', color: '#fff' }}>Hủy HĐ</button>
                              )}
                              <button 
                                onClick={() => { setSelectedInvoice(h); setShowDetailModal(true) }} 
                                className="btn" 
                                style={{ padding: '4px 8px', fontSize: '11px', background: '#6b7280', color: '#fff' }}
                              >
                                Chi tiết
                              </button>
                            </div>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              </div>
            )}

            {/* 8. THỐNG KÊ DOANH THU */}
            {activeTab === 'stats' && (
              <div className="panel">
                <div className="panel-head" style={{ justifyContent: 'space-between' }}>
                  <h3>Thống Kê Doanh Thu Cửa Hàng</h3>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <label className="form-label" style={{ marginBottom: 0 }}>Năm:</label>
                    <select 
                      className="form-control" 
                      style={{ width: '100px' }}
                      value={statsYear}
                      onChange={(e) => setStatsYear(e.target.value)}
                    >
                      <option value="2026">2026</option>
                      <option value="2025">2025</option>
                    </select>
                  </div>
                </div>
                <div className="panel-body">
                  <div className="stat-grid" style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '24px' }}>
                    {/* Summary card */}
                    <div className="panel" style={{ background: 'var(--surface-raised)', display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', padding: '30px' }}>
                      <span className="eyebrow">TỔNG DOANH THU THỰC TẾ NĂM {statsYear}</span>
                      <h2 style={{ fontSize: '42px', color: 'var(--accent)', margin: '15px 0' }}>
                        {totalRevenue.toLocaleString('vi-VN')} VND
                      </h2>
                      <span className="mini-note">Chỉ tính hóa đơn đã thanh toán thành công</span>
                    </div>

                    {/* Bar Chart list */}
                    <div>
                      <h4>Biểu đồ doanh thu hàng tháng năm {statsYear}</h4>
                      <div className="chart-list" style={{ marginTop: '20px' }}>
                        {monthlyRevenueData.map((rev, index) => {
                          const maxRev = Math.max(...monthlyRevenueData, 1)
                          const pct = (rev / maxRev) * 100

                          return (
                            <div key={index} className="chart-row" style={{ display: 'grid', gridTemplateColumns: '80px 1fr 140px', gap: '15px', alignItems: 'center', marginBottom: '8px' }}>
                              <span>Tháng {index + 1}</span>
                              <div className="chart-track" style={{ background: 'var(--surface-soft)', height: '14px', borderRadius: '4px', overflow: 'hidden' }}>
                                <div className="chart-bar" style={{ width: `${pct}%`, background: 'var(--accent)', height: '100%', transition: 'width 0.5s ease-in-out' }}></div>
                              </div>
                              <span style={{ textAlign: 'right', fontWeight: 'bold' }}>
                                {rev > 0 ? `${rev.toLocaleString('vi-VN')} đ` : '0 đ'}
                              </span>
                            </div>
                          )
                        })}
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            )}

            {/* 9. GIAO DIỆN KHÁCH HÀNG (CUSTOMER PORTAL) */}
            {activeTab === 'customer-booking' && currentUser.vai_tro === 'USER' && (
              <div className="workspace-grid two-col" style={{ display: 'grid', gridTemplateColumns: '1fr 2fr', gap: '24px' }}>
                
                {/* Form Đặt Lịch Hẹn Trực Tuyến */}
                <div className="panel">
                  <div className="panel-head">
                    <h3>Đặt Lịch Hẹn Làm Đẹp</h3>
                  </div>
                  <div className="panel-body">
                    {custBookingMessage && (
                      <div style={{ background: '#fef2f2', color: '#b91c1c', border: '1px solid #fee2e2', padding: '10px', marginBottom: '14px', borderRadius: '4px', fontSize: '13px' }}>
                        {custBookingMessage}
                      </div>
                    )}
                    <form onSubmit={handleCustomerBookingSubmit}>
                      <div className="form-group">
                        <label className="form-label">Chọn dịch vụ chăm sóc *</label>
                        <select 
                          className="form-control"
                          value={custBookingForm.dich_vu_id}
                          onChange={(e) => setCustBookingForm({...custBookingForm, dich_vu_id: e.target.value})}
                        >
                          {services.filter(s => s.trang_thai).map(s => (
                            <option key={s.id} value={s.id}>{s.ten_dich_vu} — {Number(s.gia_tien).toLocaleString('vi-VN')} VND</option>
                          ))}
                        </select>
                      </div>

                      <div className="form-group">
                        <label className="form-label">Chọn nhân viên thực hiện (Kỹ thuật viên)</label>
                        <select 
                          className="form-control"
                          value={custBookingForm.nhan_vien_id}
                          onChange={(e) => setCustBookingForm({...custBookingForm, nhan_vien_id: e.target.value})}
                        >
                          <option value="">Chọn ngẫu nhiên nhân viên phù hợp</option>
                          {employees.filter(emp => emp.trang_thai && emp.id !== 'NVADMIN').map(emp => (
                            <option key={emp.id} value={emp.id}>{emp.ho_ten} ({emp.vai_tro})</option>
                          ))}
                        </select>
                      </div>

                      <div className="form-group">
                        <label className="form-label">Ngày & Khung giờ hẹn *</label>
                        <input 
                          type="datetime-local" 
                          className="form-control" 
                          value={custBookingForm.thoi_gian_hen}
                          onChange={(e) => setCustBookingForm({...custBookingForm, thoi_gian_hen: e.target.value})}
                        />
                      </div>

                      <div className="form-group">
                        <label className="form-label">Mã giảm giá áp dụng (nếu có)</label>
                        <select 
                          className="form-control"
                          value={custBookingForm.khuyen_mai_id}
                          onChange={(e) => setCustBookingForm({...custBookingForm, khuyen_mai_id: e.target.value})}
                        >
                          <option value="">Không dùng mã giảm giá</option>
                          {promotions.filter(p => p.trang_thai).map(p => (
                            <option key={p.id} value={p.id}>{p.ma_giam_gia} (Giảm {p.loai_giam === 'Phan tram' ? `${p.gia_tri}%` : `${Number(p.gia_tri).toLocaleString('vi-VN')}đ`})</option>
                          ))}
                        </select>
                      </div>

                      <div className="form-group">
                        <label className="form-label">Ghi chú thêm cho nhân viên</label>
                        <textarea 
                          className="form-control"
                          rows="3"
                          value={custBookingForm.ghi_chu_khach_hang}
                          onChange={(e) => setCustBookingForm({...custBookingForm, ghi_chu_khach_hang: e.target.value})}
                          placeholder="Ví dụ: Da nhạy cảm, chỉ đặt làm buổi tối..."
                        />
                      </div>

                      <button type="submit" className="btn btn-primary" style={{ width: '100%', marginTop: '10px' }}>
                        Đồng Ý Đặt Lịch
                      </button>
                    </form>
                  </div>
                </div>

                {/* Danh Sách Lịch Sử Đặt Hẹn */}
                <div className="panel">
                  <div className="panel-head">
                    <h3>Lịch Sử Đặt Lịch Của Tôi</h3>
                  </div>
                  <div className="panel-body" style={{ overflowX: 'auto' }}>
                    <table className="data-table">
                      <thead>
                        <tr>
                          <th>Mã Booking</th>
                          <th>Dịch vụ</th>
                          <th>Nhân viên</th>
                          <th>Thời gian hẹn</th>
                          <th>Trạng thái</th>
                          <th>Hành động</th>
                        </tr>
                      </thead>
                      <tbody>
                        {bookings.filter(b => b.khachhang?.sdt === currentUser.username).map(b => (
                          <tr key={b.id}>
                            <td><strong>{b.id}</strong></td>
                            <td>{b.dichvu?.ten_dich_vu}</td>
                            <td>{b.nhanvien?.ho_ten || 'Tùy chọn'}</td>
                            <td><strong>{b.thoi_gian_hen ? b.thoi_gian_hen.replace('T', ' ').substring(0, 16) : ''}</strong></td>
                            <td>
                              <span className={`status-chip ${b.trang_thai_booking.toLowerCase()}`}>
                                {b.trang_thai_booking === 'Pending' ? 'Chờ duyệt' :
                                 b.trang_thai_booking === 'Confirmed' ? 'Đã duyệt' :
                                 b.trang_thai_booking === 'Completed' ? 'Hoàn thành' : 'Đã hủy'}
                              </span>
                            </td>
                            <td>
                              {(b.trang_thai_booking === 'Pending' || b.trang_thai_booking === 'Confirmed') && (
                                <button 
                                  onClick={() => handleCancelBooking(b.id)} 
                                  className="btn" 
                                  style={{ padding: '4px 8px', fontSize: '11px', background: '#ef4444', color: '#fff' }}
                                >
                                  Hủy lịch
                                </button>
                              )}
                            </td>
                          </tr>
                        ))}
                      </tbody>
                    </table>
                  </div>
                </div>

              </div>
            )}

          </div>
        </div>
      )}

      {/* ================= MODAL: THU TIỀN HÓA ĐƠN ================= */}
      {showPayModal && selectedInvoice && (
        <div style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          background: 'rgba(0,0,0,0.7)', display: 'grid', placeItems: 'center', zIndex: 100
        }}>
          <div className="panel" style={{ width: '400px', background: 'var(--surface-raised)', border: '1px solid var(--line)' }}>
            <div className="panel-head">
              <h3>Thu Tiền Hóa Đơn {selectedInvoice.id}</h3>
            </div>
            <div className="panel-body">
              <p>Khách hàng: <strong>{selectedInvoice.booking?.khachhang?.ho_ten}</strong></p>
              <p>Thành tiền: <strong style={{ color: 'var(--accent)', fontSize: '18px' }}>{Number(selectedInvoice.thanh_tien).toLocaleString('vi-VN')} VND</strong></p>
              
              <div className="form-group" style={{ marginTop: '15px' }}>
                <label className="form-label">Chọn phương thức thanh toán</label>
                <select 
                  className="form-control"
                  value={paymentMethod}
                  onChange={(e) => setPaymentMethod(e.target.value)}
                >
                  <option value="Tien mat">Tiền mặt (Tien mat)</option>
                  <option value="Chuyen khoan">Chuyển khoản (Chuyen khoan)</option>
                </select>
              </div>

              <div style={{ display: 'flex', gap: '10px', marginTop: '20px' }}>
                <button onClick={handlePayInvoice} className="btn btn-primary" style={{ flex: 1 }}>Xác Nhận Đã Thu</button>
                <button 
                  onClick={() => { setShowPayModal(false); setSelectedInvoice(null) }} 
                  className="btn" 
                  style={{ background: '#6b7280', color: '#fff' }}
                >
                  Đóng
                </button>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* ================= MODAL: BIÊN LAI CHI TIẾT (RETRO INVOICE RECEIPT) ================= */}
      {showDetailModal && selectedInvoice && (
        <div style={{
          position: 'fixed', top: 0, left: 0, right: 0, bottom: 0,
          background: 'rgba(0,0,0,0.7)', display: 'grid', placeItems: 'center', zIndex: 100
        }}>
          <div className="panel" style={{ width: '450px', background: '#f5f5f5', border: '2px dashed #000', color: '#000', fontFamily: 'monospace', padding: '10px' }}>
            <div style={{ textAlign: 'center', borderBottom: '1px dashed #000', paddingBottom: '10px' }}>
              <h2 style={{ margin: 0, fontFamily: 'monospace' }}>EZBOOK SALON</h2>
              <p style={{ margin: '5px 0' }}>Hóa đơn biên lai thanh toán</p>
              <p style={{ margin: 0, fontSize: '12px' }}>Mã HĐ: {selectedInvoice.id} | Ngày: {selectedInvoice.thoi_gian_thanh_toan ? selectedInvoice.thoi_gian_thanh_toan.replace('T', ' ').substring(0, 16) : 'Chưa thanh toán'}</p>
            </div>
            
            <div style={{ padding: '15px 0', borderBottom: '1px dashed #000', fontSize: '13px' }}>
              <p style={{ margin: '4px 0' }}>Khách hàng: <strong>{selectedInvoice.booking?.khachhang?.ho_ten}</strong></p>
              <p style={{ margin: '4px 0' }}>Điện thoại: {selectedInvoice.booking?.khachhang?.sdt}</p>
              <p style={{ margin: '4px 0' }}>Dịch vụ sử dụng: {selectedInvoice.booking?.dichvu?.ten_dich_vu}</p>
              <p style={{ margin: '4px 0' }}>Thời gian thực hiện: {selectedInvoice.booking?.thoi_gian_hen ? selectedInvoice.booking?.thoi_gian_hen.replace('T', ' ').substring(0, 16) : ''}</p>
            </div>

            <div style={{ padding: '15px 0', fontSize: '13px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', margin: '4px 0' }}>
                <span>Giá trị dịch vụ gốc:</span>
                <span>{Number(selectedInvoice.tong_tien_goc).toLocaleString('vi-VN')} đ</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', margin: '4px 0' }}>
                <span>Tiền được giảm giá:</span>
                <span>-{Number(selectedInvoice.tien_giam_gia).toLocaleString('vi-VN')} đ</span>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', margin: '8px 0 4px', fontWeight: 'bold', fontSize: '15px', borderTop: '1px dashed #000', paddingTop: '10px' }}>
                <span>THÀNH TIỀN:</span>
                <span>{Number(selectedInvoice.thanh_tien).toLocaleString('vi-VN')} đ</span>
              </div>
              <p style={{ margin: '8px 0 0', fontSize: '12px' }}>Phương thức: {selectedInvoice.phuong_thuc_thanh_toan || 'Chưa thực hiện'}</p>
              <p style={{ margin: '4px 0 0', fontSize: '12px' }}>Trạng thái: <strong>{selectedInvoice.trang_thai_thanh_toan.toUpperCase()}</strong></p>
            </div>

            <div style={{ textAlign: 'center', borderTop: '1px dashed #000', paddingTop: '10px', fontSize: '11px' }}>
              <p style={{ margin: 0 }}>Cảm ơn quý khách đã tin tưởng và sử dụng dịch vụ của EzBook!</p>
              <button 
                onClick={() => { setShowDetailModal(false); setSelectedInvoice(null) }} 
                className="btn" 
                style={{ marginTop: '15px', background: '#000', color: '#fff', border: 'none', padding: '6px 15px', cursor: 'pointer', fontFamily: 'monospace' }}
              >
                Đóng Biên Lai
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Footer */}
      <footer style={{
        background: 'var(--surface-raised)',
        padding: '15px 20px',
        textAlign: 'center',
        borderTop: '1px solid var(--line)',
        fontSize: '12px',
        color: 'var(--muted)',
        marginTop: 'auto'
      }}>
        © 2026 EzBook Workspace - Phong cách Neo-Brutalist & Graphite. Hoạt động trên Vercel Cloud và Supabase Cloud.
      </footer>
    </div>
  )
}
