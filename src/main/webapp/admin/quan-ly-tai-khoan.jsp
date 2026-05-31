<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Tai Khoan</title>
</head>
<body>
<div style="width: 980px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Quan Ly Tai Khoan (Admin)</h2>
    <p>
        <a href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Ve giao dien nhan vien</a>
        | <a href="${pageContext.request.contextPath}/account/ho-so">Ho so ca nhan</a>
        | <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
    </p>

    <c:if test="${param.msg == 'status-updated'}">
        <p style="color: green;">Cap nhat trang thai tai khoan thanh cong.</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p style="color: red;">Co loi: ${param.error}</p>
    </c:if>

    <h3>Tai Khoan Nhan Vien (ADMIN/STAFF)</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="width:100%; border-collapse: collapse; margin-bottom: 24px;">
        <thead>
        <tr>
            <th>Username</th>
            <th>Ho ten</th>
            <th>So dien thoai</th>
            <th>Vai tro</th>
            <th>Trang thai</th>
            <th>Hanh dong</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${accounts}" var="acc">
            <c:if test="${acc.role == 'ADMIN' || acc.role == 'STAFF'}">
                <tr>
                    <td>${acc.username}</td>
                    <td>${acc.fullName}</td>
                    <td>${acc.phone}</td>
                    <td>${acc.role}</td>
                    <td>
                        <c:choose>
                            <c:when test="${acc.active}">Hoat dong</c:when>
                            <c:otherwise>Bi khoa</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post" style="margin:0;">
                            <input type="hidden" name="username" value="${acc.username}">
                            <input type="hidden" name="currentStatus" value="${acc.active}">
                            <button type="submit">
                                <c:choose>
                                    <c:when test="${acc.active}">Khoa</c:when>
                                    <c:otherwise>Mo khoa</c:otherwise>
                                </c:choose>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:if>
        </c:forEach>
        </tbody>
    </table>

    <h3>Tai Khoan Khach Hang (USER)</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="width:100%; border-collapse: collapse;">
        <thead>
        <tr>
            <th>Username</th>
            <th>Ho ten</th>
            <th>So dien thoai</th>
            <th>Vai tro</th>
            <th>Trang thai</th>
            <th>Hanh dong</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${accounts}" var="acc">
            <c:if test="${acc.role == 'USER'}">
                <tr>
                    <td>${acc.username}</td>
                    <td>${acc.fullName}</td>
                    <td>${acc.phone}</td>
                    <td>${acc.role}</td>
                    <td>
                        <c:choose>
                            <c:when test="${acc.active}">Hoat dong</c:when>
                            <c:otherwise>Bi khoa</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post" style="margin:0;">
                            <input type="hidden" name="username" value="${acc.username}">
                            <input type="hidden" name="currentStatus" value="${acc.active}">
                            <button type="submit">
                                <c:choose>
                                    <c:when test="${acc.active}">Khoa</c:when>
                                    <c:otherwise>Mo khoa</c:otherwise>
                                </c:choose>
                            </button>
                        </form>
                    </td>
                </tr>
            </c:if>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
