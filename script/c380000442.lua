--Emergency Contract Laundering
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={46259438}
s.listed_series={0xae}
function s.tgfilter(c)
	return c:IsCode(46259438) or c:IsSetCard(0xae)
end
s.filter=aux.FilterFaceupFunction(Card.IsSetCard,0xae)
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--Send 1 "Contract Laundering" or "Dark Contract" card to the Graveyard
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
	--Destroy all face-up "Dark Contract" cards on your field
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ONFIELD,0,nil)
	if #sg>0 then
		for tc in aux.Next(sg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
		end
	end
	local ct=Duel.SendtoGrave(sg,REASON_DESTROY)
	if ct==0 then return end
	Duel.BreakEffect()
	--Increase your Life Points by the number of destroyed "Dark Contract" cards x 1000
	local lp=Duel.GetLP(tp)+ct*1000
	Duel.SetLP(tp, lp)
end
