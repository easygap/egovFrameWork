/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.example.sample.web;

import java.io.IOException;
import java.util.List;

import egovframework.example.sample.service.EgovSampleService;
import egovframework.example.sample.service.SampleDefaultVO;
import egovframework.example.sample.service.SampleVO;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springmodules.validation.commons.DefaultBeanValidator;

/**
 * @Class Name : EgovSampleController.java
 * @Description : EgovSample Controller Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Controller
public class EgovSampleController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleController.class);

	/** EgovSampleService */
	@Resource(name = "sampleService")
	private EgovSampleService sampleService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	/**
	 * 글 목록을 조회한다. (pageing)
	 * @param searchVO - 조회할 정보가 담긴 SampleDefaultVO
	 * @param model
	 * @return "board/boardList"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardList.do")
	public String selectSampleList(@ModelAttribute("searchVO") SampleDefaultVO searchVO, ModelMap model) throws Exception {	
		
		LOGGER.debug("*****컨트롤러입니다.*****");
		
		/** EgovPropertyService.sample */
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		/** pageing setting */
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<?> sampleList = sampleService.selectList(searchVO);
		LOGGER.debug("sampleList : " + sampleList);
		model.addAttribute("resultList", sampleList);

		int totCnt = sampleService.selectCount(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		model.addAttribute("paginationInfo", paginationInfo);

		return "board/boardList";
	}
	
	/**
	 * 글을 등록한다.
	 * @param sampleVO - 등록할 정보가 담긴 VO
	 * @param status
	 * @return "forward:/board/boardList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.POST)
	public String insertBoard(@ModelAttribute("sampleVO") SampleVO sampleVO, BindingResult bindingResult, Model model, SessionStatus status)
			throws Exception {
		
		LOGGER.debug("*****	Title : " + sampleVO.getTitle() + " Writer : " + sampleVO.getWriter() + " Contents : " + sampleVO.getContents() + " Date : " + sampleVO.getDate());

		// Server-Side Validation
		beanValidator.validate(sampleVO, bindingResult);	

		if (bindingResult.hasErrors()) {
			model.addAttribute("sampleVO", sampleVO);
			return "/board/boardWriter";
		}

		sampleService.insertBoard(sampleVO);
		status.setComplete();    // submit 중복 방지
		return "forward:/board/boardList.do";
	}
	
	/**
	 * 글 등록 화면을 조회한다.  
	 * @param searchVO - 목록 조회조건 정보가 담긴 VO
	 * @param model
	 * @return "board/boardWrite"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.GET)
	public String addSampleView(@ModelAttribute("searchVO") SampleDefaultVO searchVO, Model model) throws Exception {
		model.addAttribute("sampleVO", new SampleVO());
		return "board/boardWrite";
	}

	/**
	 * 글 상세보기 화면을 조회한다.  
	 * @param lst - 게시글 번호 정보가 담긴 파라미터 값
	 * @param model
	 * @return "/board/boardView"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardView.do", method = RequestMethod.POST)
	public String selectView(@RequestParam("selectedId") int lst, SampleVO sampleVO, Model model) throws Exception {
		
		sampleVO.setNum(lst);
		
		model.addAttribute("sampleVO", sampleService.boardView(sampleVO));
		sampleService.increaseView(lst);
		
		return "/board/boardView";
	}
	
	/**
	 * 비밀번호 일치 여부를 체크한다.  
	 * @param lst - 게시글 번호 정보가 담긴 파라미터 값
	 * @param model
	 * @return "/board/boardView"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/checkPassword.do", method = RequestMethod.POST)
	public void checkPassword(@RequestParam("num") int num, @RequestParam("password") String password, HttpServletResponse resp, SampleVO sampleVO) throws Exception {
	    LOGGER.debug("num : " + num + ", password : " + password);
	    sampleVO.setNum(num);
	    sampleVO.setPassword(password);
	    
	    int vo = sampleService.checkPassword(sampleVO);
	    
	    LOGGER.debug("**VO의 값은? : " + vo + "**");
	    
	    resp.getWriter().print(vo);
	}
}