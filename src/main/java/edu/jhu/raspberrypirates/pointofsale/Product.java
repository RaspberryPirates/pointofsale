package edu.jhu.raspberrypirates.pointofsale;

import java.math.BigDecimal;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import lombok.Getter;
import lombok.Setter;

@Document
public class Product {
	@Id
	private ObjectId id;
	
	@Getter @Setter
	private String name;
	
	@Getter @Setter
	private BigDecimal price;
	
	@Getter @Setter
	private String imageUrl;
}
