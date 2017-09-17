package edu.jhu.raspberrypirates.pointofsale;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class ProductService {
	private ProductRepository repo;
	
	public ProductService(ProductRepository repo) {
		this.repo = repo;
	}
	
	public List<Product> getAll() {
		List<Product> all = new ArrayList<Product>();
		for (Iterator<Product> it = repo.findAll().iterator(); it.hasNext();) {
			all.add(it.next());
		}
		return all;
	}
	
	public Product getById(String id) {
		return repo.findOne(id);
	}
	
	public Product create(Product p) {
		return repo.save(p);
	}
}
