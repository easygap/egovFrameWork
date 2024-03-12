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
import egovframework.rte.psl.dataaccess.util.EgovMap;
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
 * Description : 게시글 공통 클래스 
 * 작성일 : 2024.03.06
 * 작성자 : ljs
 * Input Argument:
 * 		1) LOGGER : log4j2.xml 설정에 따른 로그 출력
 *      2) sampleService : 게시글 서비스 클래스
 *      3) propertiesService : context-properties.xml 설정을 불러옴
 *      4) beanValidator : @ModelAttribute이 적용된 빈에 대해 각각의 필드 타입으로 변환
 * 수정이력 :
 *      1) 2024.03.06 selectSampleList 함수 추가 등 게시글 리스트 및 검색 구현
 *      2) 2024.03.07 addSampleView, insertBoard 함수 추가 등 게시글 등록 구현
 *      3) 2024.03.08 selectView 함수 추가 등 게시글 상세보기 및 조회수 증가 구현
 *      4) 2024.03.11 checkPassword 함수 추가 등 비동기 방식 비밀번호 검증 구현
 *      5) 2024.03.12 boardDelete, selectBoardEdit, boardEdit 함수 추가 등 게시글  삭제 / 수정 구현
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
		
		//페이징 처리 pageUnit: 10, pageSize: 10
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		/** pageing setting */
		PaginationInfo paginationInfo = new PaginationInfo();    //페이징 정보 객체 생성
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());    //현재 페이지 번호
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());    //페이지당 보여질 레코드 수 설정
		paginationInfo.setPageSize(searchVO.getPageSize());    //페이지 링크로 표시할 페이지 수 설정

 		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		List<EgovMap> sampleList = sampleService.selectList(searchVO);
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
		
		//@ModelAttribute이 적용된 빈에 대해 각각의 필드 타입으로 변환을 시도한 후 변환에 성공한 필드에 대해서만 BeanValidation 적용
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
	public String addSampleView(SampleVO sampleVO, Model model) throws Exception {
		model.addAttribute("sampleVO", sampleVO);
		return "board/boardWrite";
	}

	/**
	 * 글 상세보기 화면을 조회한다.  
	 * @param num - 게시글 번호 정보가 담긴 파라미터 값
	 * @param model
	 * @return "/board/boardView"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardView.do", method = RequestMethod.POST)
	public String selectView(@RequestParam("selectedId") int num, SampleVO sampleVO, Model model) throws Exception {
		
		sampleVO.setNum(num);
		
		model.addAttribute("sampleVO", sampleService.boardView(sampleVO));
		sampleService.increaseView(num);
		
		return "/board/boardView";
	}
	
	/**
	 * 비밀번호 일치 여부를 체크한다.  
	 * @param num - 게시글 번호 정보가 담긴 파라미터 값
	 * @param password - 사용자가 입력한 패스워드
	 * @param resp - 비동기 방식 응답
	 * @param sampleVO - VO타입으로 쿼리 조회
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/checkPassword.do", method = RequestMethod.POST)
	public void checkPassword(@RequestParam("num") int num, @RequestParam("password") String password, HttpServletResponse resp, SampleVO sampleVO) throws Exception {
	    sampleVO.setNum(num);
	    sampleVO.setPassword(password);
	    
	    int vo = sampleService.checkPassword(sampleVO);
	    
	    resp.getWriter().print(vo);
	}
	
	/**
	 * 게시글을 삭제한다.  
	 * @param num - 게시글 번호 정보가 담긴 파라미터 값
	 * @param model
	 * @return 
	 * @return "/board/boardView"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardDelete.do", method = RequestMethod.GET)
	public String boardDelete(@RequestParam("num") int num) {
		try {
			sampleService.boardDelete(num);
		} catch (Exception e) {
			return "/";
		}
		return "forward:/board/boardList.do";
	}
	
	/**
	 * 글 수정 페이지로 이동한다.  
	 * @param sampleVO - 글의 정보가 담긴 vo
	 * @param model
	 * @return "board/boardEdit"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/selectBoardEdit.do", method = RequestMethod.GET)
	public String selectBoardEdit(@RequestParam("num") int num, SampleVO sampleVO, Model model) throws Exception {
		sampleVO.setNum(num);
		model.addAttribute("sampleVO", sampleService.boardView(sampleVO));
		return "board/boardEdit";
	}
	
	/**
	 * 글을 수정한다.
	 * @param sampleVO - 등록할 정보가 담긴 VO
	 * @param status
	 * @return "forward:/board/boardList.do"
	 * @exception Exception
	 */
	@RequestMapping(value = "/board/boardEdit.do", method = RequestMethod.POST)
	public String boardEdit(@RequestParam("num") int num, @ModelAttribute("sampleVO") SampleVO sampleVO, BindingResult bindingResult, Model model, SessionStatus status)
			throws Exception {
		LOGGER.debug("********** 진입 boardEdit **********");
		sampleVO.setNum(num);
		
		LOGGER.debug("*****	Title : " + sampleVO.getTitle() + " Contents : " + sampleVO.getContents() + "**********");
		
		// 유효성 검증
		beanValidator.validate(sampleVO, bindingResult);	

		if (bindingResult.hasErrors()) {
			model.addAttribute("num", sampleVO.getNum());
			return "/board/selectBoardEdit.do";
		}
		sampleService.boardEdit(sampleVO);
		status.setComplete();    // submit 중복 방지
		
		model.addAttribute("selectedId", sampleVO.getNum());
		
		return "forward:/board/boardView.do";
	}
}