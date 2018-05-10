package com.atguigu.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.bean.Msg;
import com.atguigu.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

//处理员工的CRUD请求
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;

	/* 单个批量二合一 */
	// 如果是批量删除，多个id可用横杠隔开，1-2-3
	@ResponseBody
	@RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
	public Msg deleteEmp(@PathVariable("ids") String ids) {
		if (ids.contains("-")) {
			// 批量删除
			String[] str_ids = ids.split("-");
			List<Integer> del_ids = new ArrayList<>();
			// 组装id
			for (String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			employeeService.deleteBatch(del_ids);
		} else {
			// 单个删除
			Integer id = Integer.parseInt(ids);
			employeeService.deleteEmp(id);
		}

		return Msg.success();
	}

	/* 员工更新方法 */

	// AJAX
	// PUT请求引发的血案：PUT请求中的数据request.getParameter拿不到数据，原因是tomcat一看是put请求就不会封装请求数据map,只有post请求才封装请求。

	// 如果直接发送ajax=PUT请求， 封装的数据除了ID，其余全为空值
	// 问题所在： 请求中有数据，但employee对象封装不上，导致sql拼接不正常，
	// 原因:tomcat将请求中的数据会封装一个map， request.getParameter("empName")就会从这个map中取值，
	// springMVC封装POJO对象的时候会把pojo每个属性的值通过request.getParameter("email")拿到;

	// SpringMvc解决方案：
	// 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
	// 1、配置上HttpPutFormContentFilter；
	// 2、他的作用；将请求体中的数据解析包装成一个map。
	// 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据

	// 员工更新方法
	@ResponseBody
	@RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
	public Msg saveEmp(Employee employee, HttpServletRequest request) {
		System.out.println("请求中的值：" + request.getParameter("gender"));
		System.out.println("将要更新的员工数据：" + employee.toString());
		employeeService.updateEmp(employee);
		return Msg.success();
	}

	/* 根据id查询用户姓名 */
	@RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id") Integer id) {
		Employee employee = employeeService.getEmp(id);
		return Msg.success().add("emp", employee);
	}

	/* 检验用户名是否可用 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkUser(@RequestParam("empName") String empName) {
		// 先判断用户名是否是合法的表达式
		String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
		if (!empName.matches(regx)) {
			return Msg.fail().add("va_msg", "用户名应该是6-16位的英文和数字的组合或者是是2-5位中文");
		}
		// 数据库用户名重复校验
		boolean isOK = employeeService.checkUser(empName);
		if (isOK)
			return Msg.success();
		else
			return Msg.fail().add("va_msg", "用户名不可用");
	}

	/*
	 * 要支持JSR303校验， 需要导入Hibeernate-validator依赖
	 **/
	/* 员工保存 */
	@RequestMapping(value = "/emp", method = RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result) {
		if (result.hasErrors()) {
			// 校验失败，在模态框中显示校验失败
			Map<String, Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for (FieldError error : errors) {
				System.out.println("错误的字段名：" + error.getField());
				System.out.println("错误信息：" + error.getDefaultMessage());
				map.put(error.getField(), error.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		} else {
			employeeService.saveEmp(employee);
			return Msg.success();
		}
	}

	/* ResponseBody的正常工作需要导入jackson包，负责将对象转换为json字符串 */
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
		// 这不是一个分页查询
		// 引入pagehelper分页插件
		// 在查询之前只需调用,穿入页码，以及每页的大小
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用PageInfo包装查询后的结果，只需要将pageinfo交给页面就行了
		// 封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		return Msg.success().add("pageInfo", page);
	}

	/* 查询员工数据（分页查询） */
	// @RequestMapping("/emps")
	public String getEmps(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
		// 这不是一个分页查询
		// 引入pagehelper分页插件
		// 在查询之前只需调用,传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用PageInfo包装查询后的结果，只需要将pageinfo交给页面就行了
		// 封装了详细的分页信息，包括我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		model.addAttribute("pageInfo", page);
		return "list";
	}
}
