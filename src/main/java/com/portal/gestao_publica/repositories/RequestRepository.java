package com.portal.gestao_publica.repositories;

import com.portal.gestao_publica.models.Request;
import com.portal.gestao_publica.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface RequestRepository extends JpaRepository<Request, UUID> {
    List<Request> findAllByRequester(User user);
}
