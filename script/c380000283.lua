--Kuribohmorph
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={CARD_KURIBOH,33245030,50185950,46613515}
s.listed_series={0xa4}
function s.filter(c)
	return c:IsSetCard(0xa4) and (not c:IsPublic() or c:IsFaceup())
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--reveal or choose 1 kuriboh
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local seq=nil
	local pos=nil
	if g:GetFirst():IsLocation(LOCATION_MZONE) then
		Duel.HintSelection(g)
		seq=g:GetFirst():GetSequence()
		pos=g:GetFirst():GetPosition()
	else
		Duel.ConfirmCards(1-tp,g)
	end
	local ocode=g:GetFirst():GetOriginalCode()
	g:GetFirst():ResetEffect(RESETS_REDIRECT,RESET_EVENT)
	Duel.SendtoDeck(g:GetFirst(),nil,-2,REASON_RULE)
	--remove the kuriboh you chose from the array
	local p=1
	local cards={CARD_KURIBOH,33245030,50185950,46613515}
	for i=1,4 do
		if ocode~=cards[i] then cards[p]=cards[i] p=p+1 end
	end
	cards[p]=nil
	--choose which kuriboh its going to transform
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards))
	local token=Duel.CreateToken(tp,code)
	if g:GetFirst():IsPreviousLocation(LOCATION_MZONE) then
		--Move to field
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		token:RegisterEffect(e0)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,pos,true,(1<<seq))
		e0:Reset()
	else
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	end
end
