package com.petmillie.reservation.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.petmillie.reservation.vo.ReservaionVO;

@Repository("reservaionDAO")
public class ReservaionDAOImpl implements ReservaionDAO {

    @Autowired
    private SqlSession sqlSession;

}
