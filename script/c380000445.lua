--Red-Eyes Roulette
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={45948430,5405694,73694478}
s.listed_series={0x3b}
function s.exfilter(c)
	return c:IsMonster() and c:IsSetCard(0x3b)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,10,nil,0x3b)
	and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_DECK,0,5,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		--skill
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return aux.CanActivateSkill(tp)
	and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x3b)
end
s.cards = {
	39357122, 70781052, 17871506, 64271667, 85651167, 423705
}
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--Select 1 monster from the list and add it to your Deck from outside of the Deck
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
	local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(s.cards))
	local token=Duel.CreateToken(tp,code)
	Duel.SendtoDeck(token,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	--Add 1 random "Red-Eyes" card from your Deck to your hand
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x3b):RandomSelect(tp,1)
	if #g>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	--Return 1 "Red-Eyes" card from your hand to your Deck
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x3b):GetFirst()
	if sg then
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	end
end
