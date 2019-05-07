<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
</head>
<body>
<div style="background:#fff; font-family:'Segoe UI', 'Microsoft YaHei'; margin:0; padding:0; width:100%;">
<table align="center" width="625" cellspacing="0" cellpadding="0" border="0">
    <tbody>
        <tr>
            <td style="padding: 0 0 35px; text-align: centerz; max-height: 40px;">
                <img src="${baseUrl}/assets/img/logo.png" alt="Logo" style="max-height: 40px;" />
            </td>
        </tr>
        <tr>
            <td style="color: #000000; font-size: 30px; padding: 0 0 10px;">
                	重置密码
            </td>
        </tr>
        <tr>
            <td style="color: #484848; font-size: 18px; line-height: 24px; padding: 0 30px 35px 0;">
			           我们已收到您(${username})在Easy Online Judge的密码重置请求。<br><br>
				如果您没有重置密码，那么您可以忽略此电子邮件，并且不会更改您的密码。链接的有效期为24小时。
            </td>
        </tr>
        <tr>
            <td>
                <a href="${baseUrl}/accounts/reset-password?email=${email}&token=${token}" style="background-color: #f43636; border: 0; color: #fff; display: block; padding: 9px 12px 10px; line-height: 22px; width: 150px; text-align: center; text-decoration: none; border-radius: 6px;" target="_blank">重置密码</a>
            </td>
        </tr>
    </tbody>
</table>
</div>
</body>
</html>