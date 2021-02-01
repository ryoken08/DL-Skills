--Grit
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
	Duel.Hint(HINT_CARD,tp,id)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd
	if Duel.GetFlagEffect(ep,id+1)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetLP(tp)>=4000
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	--skill is active flag
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Activate
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.condition1)
	e1:SetOperation(s.activate1)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.condition2)
	e2:SetOperation(s.activate2)
	Duel.RegisterEffect(e2,tp)
	--flip back if LP<4000
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetCondition(s.con2)
	e3:SetOperation(s.op2)
	Duel.RegisterEffect(e3,tp)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=Duel.GetLP(tp) and Duel.GetFlagEffect(ep,id)>0
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	e3:SetOperation(s.damop)
	Duel.RegisterEffect(e3,tp)
	Duel.SetLP(tp,1)
	--one sp summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.limittg)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	end
	e1:SetLabel(spc)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e2:SetValue(s.countval)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(ep,id+1,0,0,0)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,0)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_DAMAGE)
	local e2=Duel.IsPlayerAffectedByEffect(tp,EFFECT_REVERSE_RECOVER)
	local rd=e1 and not e2
	local rr=not e1 and e2
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex and (cp==tp or cp==PLAYER_ALL) and not rd and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) 
		and cv>=Duel.GetLP(tp) then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	return ex and (cp==tp or cp==PLAYER_ALL) and rr and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NO_EFFECT_DAMAGE) 
		and cv>=Duel.GetLP(tp) and Duel.GetFlagEffect(tp,id)>0
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetLabel(cid)
	e3:SetValue(s.refcon)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
	Duel.SetLP(tp,1)
	--one sp summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.limittg)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	end
	e1:SetLabel(spc)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	e2:SetValue(s.countval)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(ep,id+1,0,0,0)
end
function s.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0
	else return val end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)~=0 and Duel.GetLP(tp)<4000
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
	Duel.ResetFlagEffect(tp,id)
end
function s.limittg(e,c,tp)
	local sp=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	return sp-e:GetLabel()>=1
end
function s.countval(e,re,tp)
	local sp=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if sp-e:GetLabel()>=1 then return 0 else return 1-sp+e:GetLabel() end
end
