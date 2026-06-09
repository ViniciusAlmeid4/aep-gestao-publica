package com.portal.gestao_publica.dtos;

import com.portal.gestao_publica.enums.RolesEnum;
import com.portal.gestao_publica.models.Address;

import java.time.LocalDate;
import java.util.UUID;

public record PostUserRequestDTO(
        UUID id,
        String name,
        LocalDate birthDate,
        Address address,
        String email,
        String password,
        RolesEnum role
) {
}
