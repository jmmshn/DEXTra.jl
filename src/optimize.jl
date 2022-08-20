using JuMP, Ipopt

"""
    get_model(total, funcs)

Maximized the output of a list of convex functions by
solving the following optimization problem:

Maximize:
    ∑_i F_i( x_i )
Subject to:
    ∑_i x_i = total
    x_i ≥ 0
where F_i( x_i ) is the output of exchange function i.
"""
function get_model(total::Number, funcs::Vector; limits::Vector = [])
    model = Model(Ipopt.Optimizer)
    set_silent(model)
    n = length(funcs)
    @variable(model, x[1:n] >= 0)
    @constraint(model, sum(x) <= total)
    # start the sum expression and append all the f_i symbols
    expr = Expr(:call, :+)
    for (i, (f, x)) in enumerate(zip(funcs, x))
        f_sym = Symbol("f_$(i)")
        register(model, f_sym, 1, f; autodiff = true)
        push!(expr.args, :($(f_sym)($(x))))
    end
    set_NL_objective(model, MOI.MAX_SENSE, :($(expr)))
    if !isempty(limits)
        @constraint(model, x >= limits)
    end
    # latex_formulation(model)
    # optimize!(model)
    # @show objective_value(model)
    return model
end

"""
    get_model(total, func, N)

Call get_model(total, [func, ...]) with N copies of func.
"""
function get_model(total::Number, func::Function, N::Int = 1; limits::Vector = [])
    get_model(total, repeat([func], N), limits = limits)
end
