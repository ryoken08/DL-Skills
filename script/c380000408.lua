--Odd-Eyes Evolution
--Effect is not fully implemented
local s,id=GetID()
function s.initial_effect(c)
	--Skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={53025096,16178681}
function s.cfilter(c)
	return c:IsMonster() and c:IsType(TYPE_PENDULUM) and not c:IsPublic()
end
s.filter=aux.FilterFaceupFunction(Card.IsOriginalCodeRule,53025096)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and not Duel.GetFieldCard(tp,LOCATION_PZONE,0) and not Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Rveal 1 Pendulum Monster Card in your hand
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	--Change 1 monster whose original name is "Odd-Eyes Dragon" to "Odd-Eyes Pendulum Dragon"
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.HintSelection(g)
	local tc=g:GetFirst()
	if tc then
		local seq=tc:GetSequence()
		local pos=tc:GetPosition()
		local code=tc:GetCode()
		tc:ResetEffect(RESETS_REDIRECT,RESET_EVENT)
		Duel.SendtoDeck(tc,nil,-2,REASON_RULE)
		local token=Duel.CreateToken(tp,16178681)
		--transform
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		token:RegisterEffect(e0)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,pos,true,(1<<seq))
		e0:Reset()
	end
end
