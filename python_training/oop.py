import datetime

class Employee:
    num_of_emps = 0
    raise_amount = 1.04 # 4% raise

    def __init__(self, first, last, pay):
        self.first = first
        self.last  = last
        self.pay   = pay
        self.email = first + "." + last + "@company.com"

        Employee.num_of_emps += 1

    # self argument should always be included in any instance method belonging to a class
    def fullname(self):
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):
        self.pay = int(self.pay * self.raise_amount)

    # class methods have a decorator that uses cls - a convention similar to self
    @classmethod
    def set_raise_amount(cls, amount):
        cls.raise_amount = amount

    @classmethod
    def from_string(cls, emp_str):
        first, last, pay = emp_str.split('-')
        return cls(first, last, pay)

    # a method should be static if you don't access a member or a class anywhere within that method
    @staticmethod
    def is_workday(day):
        if day.weekday() == 5 or day.weekday() == 6:
            return False
        return True

class Developer(Employee):
    raise_amount = 1.10 # 10% raise

    def __init__(self, first, last, pay, prog_lang):
        super().__init__(first, last, pay) # the params will be passed to the super constructor and be handled by Employee
        self.prog_lang = prog_lang

class Manager(Employee):
    def __init__(self, first, last, pay, employees=None):
        super().__init__(first, last, pay)
        if employees is None:
            self.employees = []
        else:
            self.employees = employees

    def add_emp(self, emp):
        if emp not in self.employees:
            self.employees.append(emp)

    def remove_emp(self, emp):
        if emp in self.employees:
            self.employees.remove(emp)

    def print_emps(self):
        for emp in self.employees:
            print('-->', emp.fullname())

# instance variables
emp_1 = Employee('Eve', 'Laina', 90000)
emp_2 = Employee('Temp', 'User', 70000)
emp_3 = Employee.from_string('Adi-VD-15000')
dev_1 = Developer('Eve', 'Laina', 90000, 'C')
dev_2 = Developer('Temp', 'User', 70000, '.NET')
mgr_1 = Manager('Sue', 'Me', 400000, [dev_1, dev_2, emp_3])

mgr_1.print_emps()

# print(dev_1.email)
# print(dev_1.prog_lang)