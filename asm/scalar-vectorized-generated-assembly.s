q15_axpy_ref:                           # @q15_axpy_ref
# %bb.0:
	blez	a3, .LBB0_16
# %bb.1:
	csrr	a7, vlenb
	li	a6, 16
	mv	a5, a7
	bltu	a6, a7, .LBB0_3
# %bb.2:
	li	a5, 16
.LBB0_3:
	bgeu	a3, a5, .LBB0_11
# %bb.4:
	li	a6, 0
.LBB0_5:
	slli	a6, a6, 1
	slli	a5, a3, 1
	lui	a7, 8
	add	a1, a1, a6
	add	a0, a0, a6
	add	a3, a2, a6
	add	a6, a2, a5
	addi	a7, a7, -1
	j	.LBB0_7
.LBB0_6:                                #   in Loop: Header=BB0_7 Depth=1
	sh	a5, 0(a3)
	addi	a3, a3, 2
	addi	a1, a1, 2
	addi	a0, a0, 2
	beq	a3, a6, .LBB0_16
.LBB0_7:                                # =>This Inner Loop Header: Depth=1
	lh	a5, 0(a1)
	lh	a2, 0(a0)
	mul	a5, a5, a4
	addw	a5, a5, a2
	lui	a2, 1048568
	bge	a2, a5, .LBB0_9
# %bb.8:                                #   in Loop: Header=BB0_7 Depth=1
	blt	a5, a7, .LBB0_6
	j	.LBB0_10
.LBB0_9:                                #   in Loop: Header=BB0_7 Depth=1
	lui	a5, 1048568
	blt	a5, a7, .LBB0_6
.LBB0_10:                               #   in Loop: Header=BB0_7 Depth=1
	mv	a5, a7
	j	.LBB0_6
.LBB0_11:
	csrr	t2, vlenb
	slli	t0, t2, 1
	sub	t1, a2, a0
	li	a6, 0
	bltu	t1, t0, .LBB0_5
# %bb.12:
	sub	a5, a2, a1
	bltu	a5, t0, .LBB0_5
# %bb.13:
	slli	a5, t2, 28
	sub	a5, a5, t2
	and	a6, a5, a3
	sub	a5, a6, a7
	divu	a5, a5, a7
	srli	a7, a7, 3
	slli	a5, a5, 4
	addi	a5, a5, 16
	mul	a7, a5, a7
	add	a7, a7, a2
	mv	t1, a0
	mv	t2, a1
	mv	t3, a2
	vsetvli	a5, zero, e16, m2, ta, ma
.LBB0_14:                               # =>This Inner Loop Header: Depth=1
	vl2re16.v	v12, (t2)
	vl2re16.v	v14, (t1)
	vwmul.vx	v8, v12, a4
	vwadd.wv	v8, v8, v14
	vnclip.wi	v12, v8, 0
	vs2r.v	v12, (t3)
	add	t3, t3, t0
	add	t2, t2, t0
	add	t1, t1, t0
	bne	t3, a7, .LBB0_14
# %bb.15:
	bne	a6, a3, .LBB0_5
.LBB0_16:
	ret
.Lfunc_end0:
	.size	q15_axpy_ref, .Lfunc_end0-q15_axpy_ref
