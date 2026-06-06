package com.portal.gestao_publica.dtos;

import com.portal.gestao_publica.enums.RolesEnum;
import com.portal.gestao_publica.models.Address;
import com.portal.gestao_publica.models.Request;
import com.portal.gestao_publica.models.User;

import java.time.LocalDate;
import java.util.UUID;

public record UserResponseDTO(
        UUID id,
        String name,
        LocalDate birthDate,
        Address address,
        String email,
        RolesEnum role
) {
    public static UserResponseDTO from(User user) {
        return new UserResponseDTO(
                user.getId(),
                user.getName(),
                user.getBirthDate(),
                user.getAddress(),
                user.getEmail(),
                user.getRole()
        );
    }
}
