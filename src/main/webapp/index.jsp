<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>员工列表</title>

<!-- GET 查询员工
	POST 保存员工
	PUT	修改员工
	DELETE 删除员工 -->


<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>

<!--开始的相对路径，找资源，以当前资源的路径为基准，经常容易处问题 
以/开始的相对路径，以服务器的路径为标准(http://localhost:3306),需要加上项目名 
http://localhost:3306/crud     -->

<!-- 引入jquery -->
<script type="text/javascript"
	src="${APP_PATH }/static/js/jquery-3.3.1.min.js"></script>
<!-- 引入样式 -->
<link
	href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- 员工修改的模态框 -->
	<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title">员工修改</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 control-label">姓名</label>
							<div class="col-sm-10">
								<p class="form-control-static" id="empName_update_static"></p>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">Email</label>
							<div class="col-sm-10">
								<input type="email" name="email" class="form-control"
									id="email_update_input" placeholder="email@atguigu.com">
								<span class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">性别</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_update_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_update_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">部门</label>
							<div class="col-sm-4">
								<!-- 部门提交部门ID -->
								<select class="form-control" name="dId">

								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 员工添加的模态框 -->
	<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">员工添加</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal">
						<div class="form-group">
							<label class="col-sm-2 control-label">姓名</label>
							<div class="col-sm-10">
								<input type="text" name="empName" class="form-control"
									id="empName_add_input" placeholder="empName"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">Email</label>
							<div class="col-sm-10">
								<input type="email" name="email" class="form-control"
									id="email_add_input" placeholder="email@atguigu.com"> <span
									class="help-block"></span>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">性别</label>
							<div class="col-sm-10">
								<label class="radio-inline"> <input type="radio"
									name="gender" id="gender1_add_input" value="M"
									checked="checked"> 男
								</label> <label class="radio-inline"> <input type="radio"
									name="gender" id="gender2_add_input" value="F"> 女
								</label>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">部门</label>
							<div class="col-sm-4">
								<!-- 部门提交部门ID -->
								<select class="form-control" name="dId">

								</select>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
				</div>
			</div>
		</div>
	</div>



	<!-- 搭建 显示页面-->
	<div class="container">
		<!-- title -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- button -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
			</div>
		</div>
		<!-- table data -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th><input type="checkbox" id="check_all" autocomplete="off" /></th>
							<th>empID</th>
							<th>empName</th>
							<th>empGender</th>
							<th>empEmail</th>
							<th>empDept</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>

					</tbody>
				</table>
			</div>
		</div>
		<!-- page info -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area"></div>
			<!-- 分页条 -->
			<div class="col-md-6" id="page_nav_area"></div>
		</div>
	</div>
	<script type="text/javascript">
		//总记录数
		var totalRecord;
		//当前页数
		var currentPage;
		//1.页面加载完成后，直接发送一个ajax请求，要到分页数据
		$(function() {
			//去首页
			to_page(1);
		});

		function to_page(pn) {
			$.ajax({
				url : "${APP_PATH}/emps",
				data : "pn=" + pn,
				type : "get",
				success : function(result) {
					//console.log(result);
					//解析并显示员工数据
					build_emps_table(result);
					//解析并显示分页信息
					build_page_info(result);
					//解析显示分页条数据
					build_page_nav(result);
				}
			});
		}

		function build_emps_table(result) {
			//先清空table
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps,
					function(index, item) {
						var checkBoxTd = $("<td></td>").append(
								$("<input />").addClass("check_item").attr(
										"type", "checkbox"));
						var empIdTd = $("<td></td>").append(item.empId);
						var empNameTd = $("<td></td>").append(item.empName);
						var genderTd = $("<td></td>").append(
								item.gender == "M" ? "男" : "女");
						var emailTd = $("<td></td>").append(item.email);
						var deptNameTd = $("<td></td>").append(
								item.department.deptName);
						var editBtn = $("<button></button>").addClass(
								"btn btn-primary btn-sm edit_btn").append(
								$("<span></span>").addClass(
										"glyphicon glyphicon-pencil")).append(
								"编辑");
						//为编辑按钮添加一个自定义属性，表示当前员工id
						editBtn.attr("edit-id", item.empId);
						var delBtn = $("<button></button>").addClass(
								"btn btn-danger btn-sm delete_btn").append(
								$("<span></span>").addClass(
										"glyphicon glyphicon-trash")).append(
								"删除");
						//为删除按钮添加一个自定义属性，表示当前删除的员工id
						delBtn.attr("del-id", item.empId);
						var btnTd = $("<td></td>").append(editBtn).append(" ")
								.append(delBtn);
						//append执行完后返回原来的元素
						$("<tr></tr>").append(checkBoxTd).append(empIdTd)
								.append(empNameTd).append(genderTd).append(
										emailTd).append(deptNameTd).append(
										btnTd).appendTo("#emps_table tbody");
					});
		}
		//解析显示分页信息
		function build_page_info(result) {
			$("#page_info_area").empty();
			$("#page_info_area").append(
					"当前第 " + result.extend.pageInfo.pageNum + " 页，总共 "
							+ result.extend.pageInfo.pages + " 页，总共 "
							+ result.extend.pageInfo.total + " 条记录");
			totalRecord = result.extend.pageInfo.total;
			currentPage = result.extend.pageInfo.pageNum;
		}
		//解析显示分页条，点击分页要能去对应的页数
		function build_page_nav(result) {
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页"));
			var prevPageLi = $("<li></li>").append(
					$("<a></a>").append(
							$("<span></span>").append("&laquo;").attr(
									"aria-hidden", "true")));
			if (!result.extend.pageInfo.hasPreviousPage) {
				firstPageLi.addClass("disabled");
				prevPageLi.addClass("disabled");
			} else {
				//为翻页元素添加事件
				firstPageLi.click(function() {
					to_page(1);
				});
				prevPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}

			//ul添加首页和前一页
			ul.append(firstPageLi).append(prevPageLi);
			$.each(result.extend.pageInfo.navigatepageNums, function(index,
					item) {
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if (result.extend.pageInfo.pageNum == item) {
					numLi.addClass("active");
				}
				numLi.click(function() {
					to_page(item)
				});
				//添加遍历页码
				ul.append(numLi);
			});
			var nextPageLi = $("<li></li>").append(
					$("<a></a>").append(
							$("<span></span>").append("&raquo;").attr(
									"aria-hidden", "true")));
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页"));
			if (!result.extend.pageInfo.hasNextPage) {
				lastPageLi.addClass("disabled");
				nextPageLi.addClass("disabled");
			} else {
				nextPageLi.click(function() {
					to_page(result.extend.pageInfo.pageNum + 1);
				});
				lastPageLi.click(function() {
					to_page(result.extend.pageInfo.pages);
				});
			}

			//添加下一页和末页
			ul.append(nextPageLi).append(lastPageLi);
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}

		//清空表当样式及内容
		function reset_form(ele) {
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}

		//点击新增按钮弹出模态框
		$("#emp_add_modal_btn").click(function() {
			//清除表单数据，表单完整重置
			/* $("#empName_add_input").val('');
			$("#email_add_input").val(''); */
			//$("#empAddModal form")[0].reset();
			reset_form("#empAddModal form");
			//发送ajax请求，得到部门信息，显示下拉列表中
			getDepts("#empAddModal select");
			//弹出模态框
			$("#empAddModal").modal({
				backdrop : "static",
				keyboard : "true"
			});
		});

		//查出所有部门信息并显示下拉列表中
		function getDepts(ele) {
			$.ajax({
				url : "${APP_PATH}/depts",
				type : "GET",
				success : function(result) {
					//console.log(result);
					//显示部门信息在下拉列表中
					$(ele).empty();
					$.each(result.extend.depts, function() {
						var optionEle = $("<option></option>").append(
								this.deptName).attr("value", this.deptId);
						optionEle.appendTo(ele);
					});
				}
			});
		}
		//校验表单数据
		function validate_add_form() {
			//拿到要校验的数据，使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if (!regName.test(empName)) {
				//alert("用户名应该是2-5位中文或者是6-16位的英文和数字的组合");
				show_validate_msg("#empName_add_input", "error",
						"用户名应该是2-5位中文或者是6-16位的英文和数字的组合");
				return false;
			} else {
				show_validate_msg("#empName_add_input", "success", "");
			}
			//校验邮箱
			var email = $("#email_add_input").val();
			var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if (!regEmail.test(email)) {
				//alert("邮箱格式不正確");
				show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
				return false;
			} else {
				show_validate_msg("#email_add_input", "success", "");
			}
			return true;
		}

		//显示校验结果的提示信息
		function show_validate_msg(ele, status, msg) {
			//清空元素之前的样式
			$(ele).parent().removeClass("has-error has-success");
			$(ele).next("span").text("");
			if (status == "success") {
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			} else if (status = "error") {
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
		}
		//后台验证填写的用户名是否已存在
		$("#empName_add_input").change(
				function() {
					var empName = this.value;
					//发送ajax请求校验用户名是否可用
					$.ajax({
						url : "${APP_PATH}/checkuser",
						data : "empName=" + empName,
						type : "POST",
						success : function(result) {
							//console.log(result.msg);
							if (result.code == 100) {
								show_validate_msg("#empName_add_input",
										"success", "用户名可用");
								$("#emp_save_btn").attr("ajax-va", "success");
							} else {
								show_validate_msg("#empName_add_input",
										"error", result.extend.va_msg);
								$("#emp_save_btn").attr("ajax-va", "error");
							}
						}
					});
				});

		//点击保存
		$("#emp_save_btn")
				.click(
						function() {
							//1. 模态框中填写的表单数据提交给服务器进行保存
							//先对提交给服务器的数据进行校验

							if (!validate_add_form()) {
								return false;
							}
							//判断之前的ajax用户名校验是否成功
							if ($(this).attr("ajax-va") == "error") {
								return false;
							}
							//2.发送ajax请求保存员工
							$
									.ajax({
										url : "${APP_PATH}/emp",
										type : "POST",
										data : $("#empAddModal form")
												.serialize(),
										success : function(result) {
											//alert(result.msg);
											if (result.code == 100) {
												//员工保存成功
												//关闭模态框
												$("#empAddModal").modal('hide');
												//来到最后一页，显示刚刚提交的数据
												//发送ajax请求，显示最后一页
												//
												to_page(totalRecord);
											} else {
												//显示失败信息
												//
												console.log(result);
												//有那个字段的信息就显示哪个字段
												if (undefined != result.extend.errorFields.email) {
													//显示邮箱错误信息
													show_validate_msg(
															"#email_add_input",
															"error",
															result.extend.errorFields.email);
												}
												if (undefined != result.extend.errorFields.empName) {
													//显示员工姓名错误信息
													show_validate_msg(
															"#empName_add_input",
															"error",
															result.extend.errorFields.empName);
												}
											}
										}
									});
						});

		//1. 我们是按钮创建之前绑定click，所以绑定不上事件
		//两种方法：1.创建按钮的时候绑定事件  2.绑定点击事件，live(),然而jQuery新版没有live方法，使用on()方法替代
		$(document).on("click", ".edit_btn", function() {
			//alert("edit");
			//1.查出部门信息，并显示部门列表
			getDepts("#empUpdateModal select");
			//2.查询员工信息，显示员工信息
			getEmp($(this).attr("edit-id"));
			//把员工id传递给模态框的更新按钮
			$("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
			//3.弹出模态框
			$("#empUpdateModal").modal({
				backdrop : "static",
				keyboard : "true"
			});
		});

		//单个删除
		$(document).on("click", ".delete_btn", function() {
			//弹出是否删除确认框
			//员工名字
			var empName = $(this).parents("tr").find("td:eq(2)").text();
			var empId = $(this).attr("del-id");
			//alert($(this).parents("tr").find("td:eq(1)").text());
			if (confirm("确认删除[   " + empName + "   ]吗?")) {
				//确认删除后，发送ajax请求确认删除
				$.ajax({
					url : "${APP_PATH}/emp/" + empId,
					type : "DELETE",
					success : function(result) {
						alert(result.msg);
						//回到本页
						to_page(currentPage);
					}
				});
			}
		});

		function getEmp(id) {
			$.ajax({
				url : "${APP_PATH}/emp/" + id,
				type : "GET",
				success : function(result) {
					//console.log(result);
					//拿到员工数据进行显示
					var empData = result.extend.emp;
					$("#empName_update_static").text(empData.empName);
					$("#email_update_input").val(empData.email);
					$("#empUpdateModal input[name=gender]").val(
							[ empData.gender ]);
					$("#empUpdateModal select").val([ empData.dId ]);
				}
			});
		}

		//点击更新，更新员工信息
		$("#emp_update_btn")
				.click(
						function() {
							//验证邮箱是否合法
							var email = $("#email_update_input").val();
							var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
							if (!regEmail.test(email)) {
								show_validate_msg("#email_update_input",
										"error", "邮箱格式不正确");
								return false;
							} else {
								show_validate_msg("#email_update_input",
										"success", "");
							}
							//发送ajax请求
							//注意：type可以发POST请求，然后data连接“&_method=PUT"，把put请求转成post发出
							//或者，type直接发PUT请求，data不必连接其他字符串，但需要在web.xml中引入HttpPutFormContentFilter
							$.ajax({
								url : "${APP_PATH}/emp/"
										+ $(this).attr("edit-id"),
								type : "PUT",
								data : $("#empUpdateModal form").serialize(),
								success : function(result) {
									//alert(result.msg);
									//关闭模态框
									$("#empUpdateModal").modal("hide");
									//回到本页面
									to_page(currentPage);
								}
							});
						});
		/*完成全选功能*/
		$("#check_all").click(function() {
			//attr获取checked属性是undefined
			//我们这些dom原生的属性使用prop获取，attr获取自定的属性值
			//以后使用prop改变和读取dom原生属性的值
			$(".check_item").prop("checked", $(this).prop("checked"));
		});
		//check_item
		$(document)
				.on(
						"click",
						".check_item",
						function() {
							//判断当前选中个数是不是5个
							var flag = $(".check_item:checked").length == ($(".check_item").length);
							$("#check_all").prop("checked", flag);
						});

		//点击全部删除，执行批量删除
		$("#emp_delete_all_btn").click(
				function() {
					var empNames = "";
					var del_idstr = "";
					//$(".check_item:checked")
					$.each($(".check_item:checked"), function() {
						empNames += $(this).parents("tr").find("td:eq(2)")
								.text()
								+ ",";
						//组装员工id字符串
						del_idstr += $(this).parents("tr").find("td:eq(1)")
								.text()
								+ "-";
					});
					//去除empName多余的逗号
					empNames = empNames.substring(0, empNames.length - 1);
					//去除员工id多余短横线
					del_idstr = del_idstr.substring(0, del_idstr.length - 1);
					if (confirm("确认删除【 " + empNames + " 】吗?")) {
						//发送ajax请求，执行删除
						$.ajax({
							url : "${APP_PATH}/emp/" + del_idstr,
							type : "DELETE",
							success : function(result) {
								alert(result.msg);
								//回到当前页面
								to_page(currentPage);
							}
						});
					}
				});
	</script>

</body>
</html>