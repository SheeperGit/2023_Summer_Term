				   // Employee gets name and address (Inheritance)
public class Employee extends Person {
	String employeeID;
	double salary;
	
	public Employee(String name, String address, String employeeID, double salary) {
		// Invokes superclass' constructor
		super(name, address);
		
		// Or you can rename fields args to be salary = s, for example;
		this.employeeID = employeeID; 
		this.salary = salary; 
	}
	
	public void foo() {
		System.out.println("foo in Employee");
	}
}
