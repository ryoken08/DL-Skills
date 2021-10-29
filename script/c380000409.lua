--Smile World
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={2099841}
s.listed_series={0x125}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Add 1 "Smile World" to your hand
	local token=Duel.CreateToken(tp,2099841)
	Duel.SendtoHand(token,nil,REASON_RULE)
	--Can only activate or use the effect of "Smile" Spell/Trap cards until the end of your opponent's next turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	--Cannot activate monster effects
	local e2=e1:Clone()
	e2:SetValue(s.aclimit2)
	Duel.RegisterEffect(e2,tp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,1),RESET_OPPO_TURN)
end
function s.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x125) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
