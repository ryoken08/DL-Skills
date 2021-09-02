--Chronomaly Resonance
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x70}
function s.cfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0x70) and c:IsMonster()
		and Duel.IsExistingMatchingCard(s.lvfilter,tp,LOCATION_HAND,0,1,nil,c:GetLevel())
end
function s.lvfilter(c,lv)
	return c:IsSetCard(0x70) and c:IsMonster() and c:IsLevelAbove(lv+1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--return 1 Chronomaly monster on your field to your hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.HintSelection(g)
	local lv=g:GetFirst():GetLevel()
	g:GetFirst():ResetEffect(RESETS_REDIRECT,RESET_EVENT)
	Duel.SendtoHand(g,nil,REASON_RULE)
	--play 1 Chronomaly monster with a Level higher than the monster you returned
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sg=Duel.SelectMatchingCard(tp,s.lvfilter,tp,LOCATION_HAND,0,1,1,nil,lv)
	local tc=sg:GetFirst()
	if tc then
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
