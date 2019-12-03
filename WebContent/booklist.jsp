<%@ page import="java.sql.*" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%
 Class.forName("oracle.jdbc.driver.OracleDriver");
 String url="jdbc:oracle:thin:@localhost:1521:orcl"; 
           /* 11g express edition은 orcl 대신 XE를 입력한다. */
 Connection dbconn=DriverManager.getConnection(url, "sys as sysdba", "201333786");
 //Statement stmt = dbconn.createStatement();
 request.setCharacterEncoding("UTF-8");
 int idChecker = 0;
 String word = request.getParameter("word");
 String createBook = request.getParameter("createThing");
 String createBookName = request.getParameter("bookname");
 String createPubs = request.getParameter("pubs");
 String createPrice = request.getParameter("price");
 String deleteId = request.getParameter("deleteTargetId");
 String updateId = request.getParameter("updateTargetId");
 String bookname = request.getParameter("bookname");
 String price =  request.getParameter("price");
 
 String query = "";
 PreparedStatement preStmt;
 Statement stmt = dbconn.createStatement();
 
 //create
 if(createBook != null) {
	 query = "INSERT INTO Book (bookid, bookname, publisher, price) VALUES ((SELECT NVL(MAX(bookid),0)+1 FROM Book), '" + createBookName+"' , '" + createPubs+ "', '" + createPrice + "' )";
	 stmt.executeQuery(query);
 }
 
 //delete 
 if(deleteId != null) {
	 query = "DELETE FROM Orders WHERE bookid =" + deleteId;
	 stmt.executeQuery(query);
	 
	 query = "DELETE FROM Book WHERE bookid =" + deleteId;
	 stmt.executeQuery(query);
 }
 
 //updateId
 if(updateId != null) {
	 query = "UPDATE Book SET BOOKNAME = '" +bookname+ "' WHERE bookid = " + updateId; 
	 stmt.executeQuery(query);
 }
 
 //search
 if(word == null){
	 query = "SELECT * FROM Book";
	 preStmt = dbconn.prepareStatement(query);
 } else {
	 query = "SELECT * FROM Book WHERE bookname LIKE ?";
	 preStmt = dbconn.prepareStatement(query);
	 preStmt.setString(1, "%"+ word +"%");
 }
 
 ResultSet myResultSet= preStmt.executeQuery();
%>

<html>

<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>** BOOK LIST **</title>
<style type="text/css">
	.search {
	width: 600px;
    text-align: center;
    }
	.hidden {
		display: none;
	}
	.addBookBox {
		width: 600px;
		margin-top: 40px;
    	display: flex;
    	flex-direction: column;
    	align-items: flex-end;
	}
	.addBookSubmitBtn {
		margin-top: 10px;
	}
</style>
<script type="text/javascript" >
window.editState = false;

function createNewBook(event) {
	let createBool = confirm("책을 추가하시겠습니까?")
	console.log(event);
	let formEl = event.parentElement.getElementsByTagName("input");
	if(createBool) {
		let bookname = formEl[0].value;
		let pubs = formEl[1].value;
		let price = formEl[2].value;
		console.log(bookname, pubs, price)
		location.href = "?createThing=true&bookname=" + bookname+ "&pubs=" +pubs+ "&price=" +price;
	}
	
}
function idDelete(delID){
    
	let deleteBool = confirm("현재 목록을 삭제하시겠습니까?");
    if(deleteBool) {
    	location.href = "?deleteTargetId=" + delID;
    }
           
}

function updateBookInfo(targetID, event) {
	if(!editState) {
		
		let editTarget = document.getElementsByClassName(targetID);
		Array.prototype.map.call(editTarget,(cur) => {
			let prevValue = cur.firstElementChild.firstElementChild.firstElementChild.textContent;
			cur.classList.add("hidden");
			cur.nextElementSibling.classList.remove("hidden");
			cur.nextElementSibling.value = prevValue;
		})
		event.textContent = "완료";
		editState = true;
	} else {
		let editTarget = document.getElementsByClassName(targetID);
		let changedValueArr = [];
		Array.prototype.map.call(editTarget,(cur) => {
			changedValue = cur.nextElementSibling.value;
			changedValueArr.push(changedValue);
			cur.classList.remove("hidden");
			cur.firstElementChild.firstElementChild.firstElementChild.textContent = changedValue;
			cur.nextElementSibling.classList.add("hidden");
		})
		
		let updateBool = confirm("수정하시겠습니까?");
		if(updateBool) {
			location.href = "?updateTargetId="+ targetID + "&bookname=" + changedValueArr[0] + "&price=" +changedValueArr[1]; 
		}
		
		editState = false;
	}
}

</script>
</head>

<body bgcolor="white" text="black" link="blue" vlink="purple" alink="red">
<form class="search" action="<%=request.getContextPath()%>/booklist.jsp" method="post">
	NAME: <input type="text" name="word"/>
	<input type="submit" value="검색"/>
</form>
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
            <span style="font-size:8pt;"><b>BOOKNAME</b></span></p>
        </td>
        <td width="150" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>PUBLISHER</b></span></p>
        </td>
        <td width="50" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>PRICE</b></span></p>
        </td>
        <td width="50" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>OrderList</b></span></p>
        </td>
        <td width="50" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>update</b></span></p>
        </td>
        <td width="50" height="20" bgcolor="#D2E9F9">
            <p align="center">
            <span style="font-size:8pt;"><b>delete</b></span></p>
        </td>
    </tr>
 <%
 if(myResultSet!=null){
  while(myResultSet.next()){
     String W_BOOKID=myResultSet.getString("bookid");
     String W_BOOKNAME=myResultSet.getString("bookname");
     String W_PUBLISHER=myResultSet.getString("publisher");
     String W_PRICE=myResultSet.getString("price");
 %>   
    <tr>
	    <td width="150" height="20">
	    	<div class=<%=W_BOOKID%> >
	    	    <p><span style="font-size:9pt;">
            	<a href="bookview.jsp?bookid=<%=W_BOOKID%>">
            	<font face="돋움체" color="black">
            	<%=W_BOOKNAME%></font></a></span></p>
	    	</div>
	    	<input class="hidden"/>
         </td>
	    <td width="150" height="20">
            <p align="center"><span style="font-size:9pt;">
            <font face="돋움체"><%=W_PUBLISHER%></font></span></p>
        </td>

        <td width="50" height="20">
        	<div class=<%=W_BOOKID%>>
            	<p align="center"><span style="font-size:9pt;">
            	<font face="돋움체"><%=W_PRICE%></font></span></p>        	
        	</div>
        	<input class="hidden"/>
        </td>
       	<td width="150" height="20">
	    	<div style = "text-align:center;">
	    	    <p>
	    	    	<span style="font-size:9pt;">
            			<a href="orderview.jsp?bookid=<%=W_BOOKID%>">
            				<font face="돋움체" color="black" >
            					주문 목록
            				</font>
            			</a>
            		</span>
            	</p>
	    	</div>
         </td>
        <td width="50" height="20">
            <p align="center"><span style="font-size:9pt;">
            <button onClick="updateBookInfo(<%=W_BOOKID%>, this)">수정</button></span></p>
        </td>
        <td width="50" height="20">
            <p align="center"><span style="font-size:9pt;">
            <button onClick="idDelete(<%=W_BOOKID%>)">삭제</button></span></p>
        </td>
    </tr>
 <%
    }
   }
   stmt.close();
   dbconn.close();
 %>    
</table>
<form class="addBookBox" method="post">
	<div>
		BOOKNAME: <input type="text" name="word"/>
	</div>
	<div>
		PUBLISHER: <input type="text" name="pubs"/>
	</div>
	<div>
		PRICE: <input type="text" name="price"/>
	</div>
	<input class="addBookSubmitBtn" onclick="createNewBook(this)" type="button" value="등록"/>
</form>
</body>
</html>