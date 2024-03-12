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
package egovframework.example.sample.service.impl;

import java.util.List;

import egovframework.example.sample.service.EgovSampleService;
import egovframework.example.sample.service.SampleDefaultVO;
import egovframework.example.sample.service.SampleVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

/**
 * @Class Name : EgovSampleServiceImpl.java
 * @Description : Sample Business Implement Class
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

@Service("sampleService")
public class EgovSampleServiceImpl extends EgovAbstractServiceImpl implements EgovSampleService {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovSampleServiceImpl.class);

	 /** TODO mybatis 사용 */
	@Resource(name="sampleMapper")
	private SampleMapper sampleDAO;
	
	/**
	 * 글 목록을 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectList(SampleDefaultVO searchVO) throws Exception {
		return sampleDAO.selectList(searchVO);
	}

	/**
	 * 글을 등록한다.
	 * @param vo - 등록할 정보가 담긴 SampleVO
	 * @return 등록 결과
	 * @exception Exception
	 */
	@Override
	public void insertBoard(SampleVO vo) throws Exception {
		//SHA-256암호화
		Encryption encryption = new Encryption();
		vo.setPassword(encryption.encrypt(vo.getPassword()));
		sampleDAO.insertBoard(vo);
	}
	
	/**
	 * @throws Exception   
	 * 글 총 갯수를 조회한다.
	 * @param searchVO - 조회할 정보가 담긴 VO
	 * @return 글 총 갯수
	 * @exception Exception
	 */
	@Override
	public int selectCount(SampleDefaultVO searchVO) throws Exception {
		return sampleDAO.selectCount(searchVO);
	}

	/**
	 * 글을 조회한다.
	 * @param vo - 조회할 정보가 담긴 SampleVO
	 * @return 조회한 글
	 * @exception Exception
	 */
	@Override
	public SampleVO boardView(SampleVO vo) throws Exception {
		SampleVO resultVO = sampleDAO.boardView(vo);
		if (resultVO == null)
			//message-common.properties 설정
			throw processException("info.nodata.msg");
		return resultVO;
	}

	/**
	 * 조회한 글의 조회수 +1.
	 * @param num - 게시글 번호
	 * @return 조회한 글
	 * @exception Exception
	 */
	@Override
	public void increaseView(int num) throws Exception {
		sampleDAO.increaseView(num);
	}

	/**
	 * 글의 비밀번호 검증.
	 * @param vo - 조회할 정보가 담긴 SampleVO
	 * @return 비밀번호 비교 결과
	 * @exception Exception
	 */
	@Override
	public int checkPassword(SampleVO vo) throws Exception {
		//SHA-256암호화
		Encryption encryption = new Encryption();
		vo.setPassword(encryption.encrypt(vo.getPassword()));
		LOGGER.debug("Impl에서 password의 값은? : " + vo.getPassword());

		return sampleDAO.checkPassword(vo);
	}

	/**
	 * 글을 삭제한다.
	 * @param num - 삭제할 게시글 번호
	 * @return 삭제 결과
	 * @exception Exception
	 */
	public void boardDelete(int num) throws Exception {
		sampleDAO.boardDelete(num);
	}
	
	/**
	 * 글을 수정한다.
	 * @param vo - 수정할 정보가 담긴 SampleVO
	 * @return void형
	 * @exception Exception
	 */
	public void boardEdit(SampleVO vo) throws Exception {
		//SHA-256암호화
		Encryption encryption = new Encryption();
		vo.setPassword(encryption.encrypt(vo.getPassword()));
		sampleDAO.boardEdit(vo);
	}
}
