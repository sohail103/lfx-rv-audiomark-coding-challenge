q15_axpy_rvv:                           # @q15_axpy_rvv
# %bb.0:
	blez	a3, .LBB1_2
.LBB1_1:                                # =>This Inner Loop Header: Depth=1
	vsetvli	a6, a3, e32, m4, ta, ma
	vle16.v	v12, (a0)
	vle16.v	v14, (a1)
	slli	a5, a6, 1
	subw	a3, a3, a6
	add	a0, a0, a5
	add	a1, a1, a5
	vsext.vf2	v8, v12
	vsetvli	zero, zero, e16, m2, ta, ma
	vwmacc.vx	v8, a4, v14
	vnclip.wi	v12, v8, 0
	vse16.v	v12, (a2)
	add	a2, a2, a5
	bgtz	a3, .LBB1_1
.LBB1_2:
	ret
.Lfunc_end1:
	.size	q15_axpy_rvv, .Lfunc_end1-q15_axpy_rvv
                                        # -- End function
