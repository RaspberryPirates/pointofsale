package edu.jhu.raspberrypirates.pointofsale;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.data.mongodb.core.MongoTemplate;

import com.mongodb.MongoClient;

import cz.jirutka.spring.embedmongo.EmbeddedMongoFactoryBean;

@SpringBootApplication
public class Application {

	public static void main(String[] args) {
		SpringApplication.run(Application.class, args);
	}
	
	private static final String MONGO_DB_URL = "localhost";
	private static final String MONGO_DB_NAME = "embedded_db";
	
	@Bean
	public MongoTemplate mongoTemplate() throws IOException {
		EmbeddedMongoFactoryBean m = new  EmbeddedMongoFactoryBean();
		m.setBindIp(MONGO_DB_URL);
		MongoClient mClient = m.getObject();
		return new MongoTemplate(mClient, MONGO_DB_NAME);
	}
}
