# Modified from Shreyas Kowshik's implementation.

include("policies.jl")
include("trpo.jl")
include("ppo.jl")

include(joinpath("utils", "utils.jl"))
include(joinpath("utils", "buffer.jl"))
include(joinpath("utils", "policy_saving.jl"))

include("rollout.jl")
include("train.jl")


function POMDPs.action(planner::Union{TRPOPlanner, PPOPlanner}, s)
    if actiontype(planner.mdp) == ASTSeedAction
        @warn "DRL solvers (TRPO/PPO) are not as effective with ASTSeedAction. Use ASTMDP{ASTSampleAction}() instead."
    end
    train!(planner) # train neural networks

    # Pass back action trace if recording is on (i.e. top_k)
    if planner.mdp.params.top_k > 0
        return get_top_path(planner.mdp)
    else
        statevec = convert_s(Vector{Float32}, s, planner.mdp)
        nn_action = get_action(planner.policy, statevec)
        ast_action = translate_ast_action(planner.mdp.sim, nn_action, actiontype(planner.mdp))
        return ast_action
    end
end


function playout(mdp::ASTMDP, planner::Union{TRPOPlanner, PPOPlanner})
    Random.seed!(mdp.params.seed) # Determinism
    s = AST.initialstate(mdp)
    return action(planner, s)
end