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
	local tc=nil
	if g:GetFirst():IsLocation(LOCATION_MZONE) then
		Duel.HintSelection(g)
		tc=g:GetFirst()
	else
		Duel.ConfirmCards(1-tp,g)
		tc=g:GetFirst()
	end
	local ocode=tc:GetOriginalCode()
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
	if tc:IsLocation(LOCATION_MZONE) then
		--transform
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
	else
		tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end
