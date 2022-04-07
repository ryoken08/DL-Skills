--Parts Separation [Wisel]
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={68140974,100000051,100000052,100000053,100000054}
function s.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_MACHINE) and c:GetLevel()==1
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,68140974,30221870),tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
	and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Return up to 2 Level 1 DARK Machine-Type monsters in your hand to your Deck
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,ct,nil)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
	--play "Wisel Top", "Wisel Attack", "Wisel Guard", or "Wisel Carrier" (max. 1 each) up to the number of monsters you have returned
	local ft=g:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local cards = {100000051, 100000052, 100000053, 100000054}
	local code={Duel.SelectCardsFromCodes(tp,ft,ft,nil,false,table.unpack(cards))}
	for i=1,ft do
		local token=Duel.CreateToken(tp,code[i])
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetOperation(function () Duel.SetChainLimitTillChainEnd(aux.FALSE) end)
		token:RegisterEffect(e0)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		e0:Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_PHASE+PHASE_END)
		token:RegisterEffect(e1)
	end
end
