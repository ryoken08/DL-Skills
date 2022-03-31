--Blaze Accelerator Reserve
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_series={0x32,0xb9}
function s.filter(c)
	return c:IsSetCard(0x32) and c:IsType(TYPE_MONSTER)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,0xb9)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,0xb9)
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,ct,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
			Duel.SendtoGrave(tc,REASON_RULE)
			if tc:IsLocation(LOCATION_REMOVED) then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
	local ft=g:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK+LOCATION_GRAVE,0,ft,ft,nil,0xb9)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,sg)
	end
end
