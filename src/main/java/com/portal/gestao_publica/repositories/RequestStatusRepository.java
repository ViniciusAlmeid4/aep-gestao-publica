package com.portal.gestao_publica.repositories;

import com.portal.gestao_publica.models.Request;
import com.portal.gestao_publica.models.RequestStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface RequestStatusRepository extends JpaRepository<RequestStatus, Long> {
    List<RequestStatus> findAllByRequest(Request request);
}
