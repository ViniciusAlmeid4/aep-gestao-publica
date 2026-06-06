package com.portal.gestao_publica.services;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.portal.gestao_publica.models.User;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;
import java.util.UUID;

@Component
public class JWTService {

    @Value("${api.security.token.secret}")
    private String secret;

    public String generateToken(User user) {
        return JWT
                .create()
                .withSubject(user.getId().toString())
                .withClaim("role", user.getRole().name())
                .withExpiresAt(Instant.now().plus(2, ChronoUnit.HOURS))
                .sign(Algorithm.HMAC256(secret));
    }

    public Optional<UUID> validateToken(String token) {
        try {
            return Optional.of(
                UUID
                    .fromString(
                        JWT
                            .require(Algorithm.HMAC256(secret))
                            .build()
                            .verify(token)
                            .getSubject()
                    )
            );
        } catch (JWTVerificationException e) {
            return Optional.empty();
        }
    }
}
