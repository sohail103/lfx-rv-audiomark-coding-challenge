q15_axpy_ref:                           # @q15_axpy_ref
# %bb.0:
	blez	a3, .LBB0_7
# %bb.1:
	slli	a3, a3, 1
	lui	a5, 8
	add	a6, a2, a3
	addi	a7, a5, -1
	j	.LBB0_3
.LBB0_2:                                #   in Loop: Header=BB0_3 Depth=1
	sh	a5, 0(a2)
	addi	a2, a2, 2
	addi	a1, a1, 2
	addi	a0, a0, 2
	beq	a2, a6, .LBB0_7
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	lh	a5, 0(a1)
	lh	a3, 0(a0)
	mul	a5, a5, a4
	addw	a5, a5, a3
	lui	a3, 1048568
	bge	a3, a5, .LBB0_5
# %bb.4:                                #   in Loop: Header=BB0_3 Depth=1
	blt	a5, a7, .LBB0_2
	j	.LBB0_6
.LBB0_5:                                #   in Loop: Header=BB0_3 Depth=1
	lui	a5, 1048568
	blt	a5, a7, .LBB0_2
.LBB0_6:                                #   in Loop: Header=BB0_3 Depth=1
	mv	a5, a7
	j	.LBB0_2
.LBB0_7:
	ret
.Lfunc_end0:
	.size	q15_axpy_ref, .Lfunc_end0-q15_axpy_ref
                                        # -- End function

