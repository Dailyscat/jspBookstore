<%@ page import="java.sql.*" contentType="text/html;charset=UTF-8"%>
<%
  Class.forName("oracle.jdbc.driver.OracleDriver");
  String url="jdbc:oracle:thin:@localhost:1521:orcl";
		/* 11g express edition은 orcl 대신 XE를 입력한다. */
  Connection dbconn=DriverManager.getConnection(url, "sys as sysdba", "201333786");
  Statement stmt = dbconn.createStatement();
  String custid=request.getParameter("custid");
  ResultSet myResultSet=stmt.executeQuery("SELECT * FROM Customer WHERE custid="+custid);
%>
<html>

<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>** Ordered Customer VIEW **</title>
</head>

<body bgcolor="white" text="black" link="blue" vlink="purple" alink="red">
<table cellpadding="0" cellspacing="0" width="600" height="23">
    <tr>
        <td width="1350">
            <p align="right"><b><a href="booklist.jsp">
            <font size="1" face="돋움체" color="black">LIST</font></a></b></p>
        </td>
    </tr>
</table>
<table border="1" cellspacing="0" width="600" bordercolor="#9AD2F7" bordercolordark="white" bordercolorlight="#B9E0FA">
    <tr>
        <td width="150" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>유저ID</b></span></p>
        </td>
        <td width="150" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>유저 이름</b></span></p>
        </td>
        <td width="150" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>주소</b></span></p>
        </td>
        <td width="150" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>phone</b></span></p>
        </td>
    </tr>
 <%
 if(myResultSet!=null){
  while(myResultSet.next()){
     String W_CUSTID=myResultSet.getString("custid");
     String W_USERNAME=myResultSet.getString("name");
     String W_ADDR=myResultSet.getString("address");
     String W_PHONE=myResultSet.getString("phone");
 %>   
    <tr>
	    <td width="50" height="20">
	    	<div >
	    	    <p align="center">
	    	    	<span style="font-size:10pt;">
            			<font face="돋움체" color="black">
            				<%=W_CUSTID%>
            			</font>
            		</span>
            	</p>
	    	</div>
         </td>
	    <td width="50" height="20">
            <p align="center"><span style="font-size:10pt;">
            <font face="돋움체"><%=W_USERNAME%></font></span></p>
        </td>

        <td width="100" height="20">
        	<div>
            	<p align="center"><span style="font-size:10pt;">
            	<font face="돋움체"><%=W_ADDR%></font></span></p>        	
        	</div>
        </td>
        <td width="100" height="20">
        	<div>
            	<p align="center"><span style="font-size:10pt;">
            	<font face="돋움체"><%=W_PHONE%></font></span></p>        	
        	</div>
        </td>
    </tr>
 <%
    }
   }
   stmt.close();
   dbconn.close();
 %>    
</table>


</body>
</html>
