from unittest import TestCase
from framework import AssemblyTest, print_coverage


class TestAbs(TestCase):
    def test_minus_one(self):
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", -1) # if we modify input and check_scalar, we can make a brand new test!
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    def test_zero(self):
        t = AssemblyTest(self, "abs.s")
        # load 0 into register a0
        t.input_scalar("a0", 0)
        # call the abs function
        t.call("abs")
        # check that after calling abs, a0 is equal to 0 (abs(0) = 0)
        t.check_scalar("a0", 0)
        # generate the `assembly/TestAbs_test_zero.s` file and run it through venus
        t.execute()

    def test_one(self):
        # same as test_zero, but with input 1
        t = AssemblyTest(self, "abs.s")
        t.input_scalar("a0", 1)
        t.call("abs")
        t.check_scalar("a0", 1)
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("abs.s", verbose=False)


class TestRelu(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "relu.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of `array0` into register a0
        t.input_array("a0", array0)
        # set a1 to the length of our array
        t.input_scalar("a1", len(array0))
        # call the relu function
        t.call("relu")
        # check that the array0 was changed appropriately
        t.check_array(array0, [1, 0, 3, 0, 5, 0, 7, 0, 9])
        # generate the `assembly/TestRelu_test_simple.s` file and run it through venus
        t.execute()

    def test_bigger(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([-1358, -1934851, 0, 55555, -91934190, -4294813, -94632])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("relu")
        t.check_array(array0, [0, 0, 0, 55555, 0, 0, 0])
        t.execute()

    def test_single1(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([-89147834])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("relu")
        t.check_array(array0, [0])
        t.execute()

    def test_single2(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([10293439])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("relu")
        t.check_array(array0, [10293439])
        t.execute()

    def test_exception1(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("relu")
        t.execute(code=115)

    def test_exception2(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([234])
        t.input_array("a0", array0)
        t.input_scalar("a1", -9374591)
        t.call("relu")
        t.execute(code=115)

    def test_bad_input(self):
        t = AssemblyTest(self, "relu.s")
        array0 = t.array([-55, 62, 300, -444, 0, 1, 7, -8, 9])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0)-4)
        t.call("relu")
        t.check_array(array0, [0, 62, 300, 0, 0, 1, 7, -8, 9])
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("relu.s", verbose=False)


class TestArgmax(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([1, -2, 3, -4, 5, -6, 7, -8, 9])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 8)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_exception1(self):
        t = AssemblyTest(self, "argmax.s")
        array0 = t.array([])
        t.input_array("a0", array0)
        t.input_scalar("a1", len(array0))
        t.call("argmax")
        t.execute(code=120)

    def test_exception2(self):
        t = AssemblyTest(self, "argmax.s")
        array0 = t.array([-91385, 999999])
        t.input_array("a0", array0)
        t.input_scalar("a1", -777)
        t.call("argmax")
        t.execute(code=120)

    def test_bigger(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([0, -29845, 324129, -440, 5999999, 0, 5999999, 0])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 4)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_single1(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-394751])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_single2(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([999990134, 999990135])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 1)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_multiple(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-777, -777, -777, -777, -777, -777, -777])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", len(array0))
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_bad_input1(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([-9, 12, 1, 0, 222, 5])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", 4)
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 1)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    def test_bad_input2(self):
        t = AssemblyTest(self, "argmax.s")
        # create an array in the data section
        array0 = t.array([90009, 66, 77, 88, 10, 5])
        # load address of the array into register a0
        t.input_array("a0", array0)
        # set a1 to the length of the array
        t.input_scalar("a1", 3)
        # call the `argmax` function
        t.call("argmax")
        # check that the register a0 contains the correct output
        t.check_scalar("a0", 0)
        # generate the `assembly/TestArgmax_test_simple.s` file and run it through venus
        t.execute()

    @classmethod
    def tearDownClass(cls):
        print_coverage("argmax.s", verbose=False)


class TestDot(TestCase):
    def test_simple(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 9)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 1)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 285)
        t.execute()

    def test_stride1(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 1)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 22)
        t.execute()

    def test_stride2(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 3)
        t.input_scalar("a3", 3)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 48) # 1*1 + 4*3 + 7*5 = 1 + 12 + 35 = 48
        t.execute()

    def test_stride3(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([5, -2, 0, 3, 1, 20, 10, 2, 4, -5])
        array1 = t.array([2, -3, 1, 0, 10, 12, 50, 10, -10, 1000])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 4) # length 4
        t.input_scalar("a3", 2) # [5, 0, 1, 10]
        t.input_scalar("a4", 3) # [2, 0, 50, 1000]
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.check_scalar("a0", 10060) # 10 + 0 + 50 + 10,000 = 10,060
        t.execute()

    def test_length_exception1(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 0)
        t.input_scalar("a3", 3)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=123)

    def test_length_exception2(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([])
        array1 = t.array([])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", -100)
        t.input_scalar("a3", -3)
        t.input_scalar("a4", 20)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=123)

    def test_stride_exception1(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        array1 = t.array([])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 9)
        t.input_scalar("a3", 0)
        t.input_scalar("a4", 2)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=124)

    def test_stride_exception2(self):
        t = AssemblyTest(self, "dot.s")
        # create arrays in the data section
        array0 = t.array([])
        array1 = t.array([1, 2, 3, 4, 5, 6, 7, 8, 9])
        # load array addresses into argument registers
        t.input_array("a0", array0)
        t.input_array("a1", array1)
        # load array attributes into argument registers
        t.input_scalar("a2", 5)
        t.input_scalar("a3", 2)
        t.input_scalar("a4", -89)
        # call the `dot` function
        t.call("dot")
        # check the return value
        t.execute(code=124)

    @classmethod
    def tearDownClass(cls):
        print_coverage("dot.s", verbose=False)


class TestMatmul(TestCase):

    def do_matmul(self, m0, m0_rows, m0_cols, m1, m1_rows, m1_cols, result, code=0):
        t = AssemblyTest(self, "matmul.s")
        # we need to include (aka import) the dot.s file since it is used by matmul.s
        t.include("dot.s")

        # create arrays for the arguments and to store the result
        array0 = t.array(m0)
        array1 = t.array(m1)
        array_out = t.array([0] * len(result))

        # load address of input matrices and set their dimensions
        t.input_array("a0", array0)
        t.input_scalar("a1", m0_rows)
        t.input_scalar("a2", m0_cols)
        t.input_array("a3", array1)
        t.input_scalar("a4", m1_rows)
        t.input_scalar("a5", m1_cols)

        # load address of output array
        t.input_array("a6", array_out)

        # call the matmul function
        t.call("matmul")

        # check the content of the output array
        t.check_array(array_out, result)

        # generate the assembly file and run it through venus, we expect the simulation to exit with code `code`
        t.execute(code=code)

    def test_simple(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150]
        )

    def test_bigger(self):
        self.do_matmul(
            [1, 2, 3, 4, 5, 6, 7, 8, 9, 9, 8, 7, 6, 5, 4, 3, 2, 1], 6, 3,
            [1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8, 1, 2, 3, 4, 5, 6, 7, 8], 3, 8,
            [6, 12, 18, 24, 30, 36, 42, 48, 15, 30, 45, 60, 75, 90, 105, 120, 24, 48, 72, 96, 120, 144, 168, 192, 24, 48, 72, 96, 120, 144, 168, 192, 15, 30, 45, 60, 75, 90, 105, 120, 6, 12, 18, 24, 30, 36, 42, 48]
        )

    def test_m0_dimensions1(self):
        self.do_matmul(
            [], 0, 5,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], 3, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=125
        )

    def test_m0_dimensions2(self):
        self.do_matmul(
            [5555], 4, -1,
            [1, 2, 3, 4, 5, 6, 7, 8, 9], -3, -43,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=125
        )

    def test_m1_dimensions1(self):
        self.do_matmul(
            [1, 1, 1, 1], 2, 2,
            [], 0, 3,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=126
        )

    def test_m1_dimensions2(self):
        self.do_matmul(
            [1, 1, 1, 1], 2, 2,
            [-4], 22, -1234,
            [30, 36, 42, 66, 81, 96, 102, 126, 150],
            code=126
        )

    def test_no_match1(self):
        self.do_matmul(
            [-1, -100, 22, 0], 2, 2,
            [0, 5, 1234, -34, 2, 1, 0, 0, 9999], 3, 3,
            [0, 1, 2],
            code=127
        )

    def test_no_match2(self):
        self.do_matmul(
            [-1, -100, 22, 0, 49, -7777], 2, 3,
            [0, 5, 1234, -34, 2, 1, 0, 0, 9999, 123], 2, 5,
            [0, 1, 2],
            code=127
        )

    @classmethod
    def tearDownClass(cls):
        print_coverage("matmul.s", verbose=False)


class TestReadMatrix(TestCase):

    file_name = ""
    arr = []

    def do_read_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "read_matrix.s")
        # load address to the name of the input file into register a0
        t.input_read_filename("a0", self.file_name)

        # allocate space to hold the rows and cols output parameters
        rows = t.array([-1])
        cols = t.array([-1])

        # load the addresses to the output parameters into the argument registers
        t.input_array("a1", rows)
        t.input_array("a2", cols)

        # call the read_matrix function
        t.call("read_matrix")

        # check the output from the function
        t.check_array_pointer("a0", self.arr)

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

    def test_simple(self):
        self.file_name = "inputs/test_read_matrix/test_input.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        self.do_read_matrix()

    def test_bigger(self):
        self.file_name = "inputs/test_read_matrix/test_input2.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.do_read_matrix()

    def test_nonsquare(self):
        self.file_name = "inputs/test_read_matrix/test_nonsquare.bin"
        self.arr = [1, 2, 3, -12934, 55, 3339, 0, -5005, 6789, 4, 5, 6, 432, -9990, -12, 0, 0, 309847221]
        self.do_read_matrix()

    def test_fopen_failure(self):
        self.file_name = "inputs/test_read_matrix/test_input.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        self.do_read_matrix(fail='fopen', code=117)

    def test_malloc_failure(self):
        self.file_name = "inputs/test_read_matrix/test_input2.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.do_read_matrix(fail='malloc', code=116)

    def test_fread_failure(self):
        self.file_name = "inputs/test_read_matrix/test_input2.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.do_read_matrix(fail='fread', code=118)

    def test_fclose_failure(self):
        self.file_name = "inputs/test_read_matrix/test_input.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        self.do_read_matrix(fail='fclose', code=119)

    @classmethod
    def tearDownClass(cls):
        print_coverage("read_matrix.s", verbose=False)


class TestWriteMatrix(TestCase):

    outfile = ""
    arr = []
    num_rows = 0
    num_cols = 0
    reference = ""

    def do_write_matrix(self, fail='', code=0):
        t = AssemblyTest(self, "write_matrix.s")

        # load output file name into a0 register
        t.input_write_filename("a0", self.outfile)

        # load input array and other arguments
        t.input_array("a1", t.array(self.arr))
        t.input_scalar("a2", self.num_rows)
        t.input_scalar("a3", self.num_cols)

        # call `write_matrix` function
        t.call("write_matrix")

        # generate assembly and run it through venus
        t.execute(fail=fail, code=code)

        # compare the output file against the reference
        if (fail == '' and code == 0):
            t.check_file_output(self.outfile, self.reference)

    def test_simple(self):
        self.outfile = "outputs/test_write_matrix/student.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        self.num_rows = 3
        self.num_cols = 3
        self.reference = "outputs/test_write_matrix/reference.bin"
        self.do_write_matrix()

    def test_bigger(self):
        self.outfile = "outputs/test_write_matrix/student1.bin"
        self.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        self.num_rows = 10
        self.num_cols = 10
        self.reference = "outputs/test_write_matrix/reference1.bin"
        self.do_write_matrix()

    def test_nonsquare(self):
        self.outfile = "outputs/test_write_matrix/student2.bin"
        self.arr = [-3, 4, 9, 0, 10, -999, 10000, 52139, 101010, -12340, 6, 4, 8, 2, 4] # 3x5 matrix
        self.num_rows = 3
        self.num_cols = 5
        self.reference = "outputs/test_write_matrix/reference2.bin"
        self.do_write_matrix()

    def test_fopen_failure(self):
        self.outfile = "outputs/test_write_matrix/student2.bin"
        self.arr = [-3, 4, 9, 0, 10, -999, 10000, 52139, 101010, -12340, 6, 4, 8, 2, 4] # 3x5 matrix
        self.num_rows = 3
        self.num_cols = 5
        self.reference = "outputs/test_write_matrix/reference2.bin"
        self.do_write_matrix(fail='fopen', code=112)

    def test_fwrite_failure(self):
        self.outfile = "outputs/test_write_matrix/student2.bin"
        self.arr = [-3, 4, 9, 0, 10, -999, 10000, 52139, 101010, -12340, 6, 4, 8, 2, 4] # 3x5 matrix
        self.num_rows = 3
        self.num_cols = 5
        self.reference = "outputs/test_write_matrix/reference2.bin"
        self.do_write_matrix(fail='fwrite', code=113)

    def test_fclose_failure(self):
        self.outfile = "outputs/test_write_matrix/student2.bin"
        self.arr = [-3, 4, 9, 0, 10, -999, 10000, 52139, 101010, -12340, 6, 4, 8, 2, 4] # 3x5 matrix
        self.num_rows = 3
        self.num_cols = 5
        self.reference = "outputs/test_write_matrix/reference2.bin"
        self.do_write_matrix(fail='fclose', code=114)

    @classmethod
    def tearDownClass(cls):
        print_coverage("write_matrix.s", verbose=False)


class TestClassify(TestCase):

    def make_test(self):
        t = AssemblyTest(self, "classify.s")
        t.include("argmax.s")
        t.include("dot.s")
        t.include("matmul.s")
        t.include("read_matrix.s")
        t.include("relu.s")
        t.include("write_matrix.s")
        return t

    def test_simple0_input0(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        t.check_scalar("a0", 2)
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # compare the output file and
        t.check_file_output(out_file, ref_file)
        # compare the classification output with `check_stdout`
        t.check_stdout("2")

    def test_simple0_input0_noprint(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference0.bin"
        args = ["inputs/simple0/bin/m0.bin", "inputs/simple0/bin/m1.bin",
                "inputs/simple0/bin/inputs/input0.bin", out_file]
        t.input_scalar("a2", 55)
        # call classify function
        t.call("classify")
        t.check_scalar("a0", 2)
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # compare the output file and
        t.check_file_output(out_file, ref_file)
        # compare the classification output with `check_stdout`
        t.check_stdout("")

    def test_simple2_input2(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference2.bin"
        args = ["inputs/simple2/bin/m0.bin", "inputs/simple2/bin/m1.bin",
                "inputs/simple2/bin/inputs/input0.bin", out_file]
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        t.check_scalar("a0", 7)
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args)
        # compare the output file and
        t.check_file_output(out_file, ref_file)
        # compare the classification output with `check_stdout`
        t.check_stdout("7")

    def test_less_argc(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference2.bin"
        args = ["inputs/simple2/bin/m0.bin"]
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args, code=121)

    def test_malloc_failure(self):
        t = self.make_test()
        out_file = "outputs/test_basic_main/student0.bin"
        ref_file = "outputs/test_basic_main/reference2.bin"
        args = ["inputs/simple2/bin/m0.bin", "inputs/simple2/bin/m1.bin",
                "inputs/simple2/bin/inputs/input0.bin", out_file]
        t.input_scalar("a2", 0)
        # call classify function
        t.call("classify")
        # generate assembly and pass program arguments directly to venus
        t.execute(args=args, code=122, fail='malloc')

    @classmethod
    def tearDownClass(cls):
        print_coverage("classify.s", verbose=False)


# The following are some simple sanity checks:
import subprocess, pathlib, os
script_dir = pathlib.Path(os.path.dirname(__file__)).resolve()

def compare_files(test, actual, expected):
    assert os.path.isfile(expected), f"Reference file {expected} does not exist!"
    test.assertTrue(os.path.isfile(actual), f"It seems like the program never created the output file {actual}!")
    # open and compare the files
    with open(actual, 'rb') as a:
        actual_bin = a.read()
    with open(expected, 'rb') as e:
        expected_bin = e.read()
    test.assertEqual(actual_bin, expected_bin, f"Bytes of {actual} and {expected} did not match!")

class TestMain(TestCase):
    """ This sanity check executes src/main.S using venus and verifies the stdout and the file that is generated.
    """
#"src/main.S",
    def run_main(self, inputs, output_id, label):
        args = [f"{inputs}/m0.bin", f"{inputs}/m1.bin",
                f"{inputs}/inputs/input0.bin",
                f"outputs/test_basic_main/student{output_id}.bin"]
        reference = f"outputs/test_basic_main/reference{output_id}.bin"

        t= AssemblyTest(self, "main.s", no_utils=True)
        t.call("main")
        t.execute(args=args)
        t.check_stdout(label)
        t.check_file_output(args[-1], reference)

    def test0(self):
        self.run_main("inputs/simple0/bin", "0", "2")

    def test1(self):
       self.run_main("inputs/simple1/bin", "1", "1")

    def test2(self):
       self.run_main("inputs/simple2/bin", "2", "7")
