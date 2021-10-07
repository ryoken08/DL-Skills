--Dueltaining Recast
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x98,0x9f,0x99}
function s.filter(c)
	return c:HasLevel() and c:IsType(TYPE_PENDULUM) and (c:IsSetCard(0x9f) or c:IsSetCard(0x98) or c:IsSetCard(0x99))
		and c:IsSummonableCard()
end
function s.tdfilter(c)
	return c:IsFaceup() and c:HasLevel() and c:IsType(TYPE_PENDULUM)
end
function s.spfilter(c,ft,sg,lv)
	return c:IsFaceup() and c:HasLevel() and c:IsType(TYPE_PENDULUM) and sg:CheckWithSumEqual(Card.GetLevel,lv,1,ft+2)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	local sg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_MZONE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local lv=sg:GetSum(Card.GetOriginalLevel)
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil,ft,g,lv)
	and sg:GetClassCount(Card.GetLevel)==3
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--add all Pendulum Monsters with different Levels to your Extra Deck
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_MZONE,0,nil)
	local lv=g:GetSum(Card.GetOriginalLevel)
	for tc in aux.Next(g) do
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
	end
	Duel.SendtoExtraP(g,nil,REASON_RULE)
	Duel.BreakEffect()
	--play "Performapal", "Magician", and/or "Odd-Eyes" Pendulum Monsters from your hand
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=g1:SelectWithSumEqual(tp,Card.GetLevel,lv,1,ft)
	for tc in aux.Next(sg) do
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		tc:RegisterEffect(e0)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
