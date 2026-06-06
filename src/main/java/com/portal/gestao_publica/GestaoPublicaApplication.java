package com.portal.gestao_publica;

import com.portal.gestao_publica.enums.RolesEnum;
import com.portal.gestao_publica.models.User;
import com.portal.gestao_publica.repositories.UserRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.password.PasswordEncoder;

@SpringBootApplication
public class GestaoPublicaApplication {

	public static void main(String[] args) {
		SpringApplication.run(GestaoPublicaApplication.class, args);
	}

	@Bean
	CommandLineRunner initData(UserRepository userRepository, PasswordEncoder passwordEncoder) {
		return args -> {
			if (userRepository.findByEmail("admin@test.com") == null) {
				User user = new User();
				user.setName("Admin");
				user.setEmail("admin@test.com");
				user.setPassword(passwordEncoder.encode("123456"));
				user.setRole(RolesEnum.FUNCIONARIO_PREFEITURA);
				userRepository.save(user);
				System.out.println("Test user created: admin@test.com / 123456");
			}
			if (userRepository.findByEmail("cidadao@test.com") == null) {
				User user = new User();
				user.setName("Cidadão");
				user.setEmail("cidadao@test.com");
				user.setPassword(passwordEncoder.encode("123456"));
				user.setRole(RolesEnum.CIDADAO);
				userRepository.save(user);
				System.out.println("Test user created: cidadao@test.com / 123456");
			}
		};
	}
}
