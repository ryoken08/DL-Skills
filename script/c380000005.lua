--Balance
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	aux.AddSkillProcedure(c,1,false)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetCondition(s.flipcon)
	e1:SetOperation(s.flipop)
	c:RegisterEffect(e1)
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,6,nil,TYPE_MONSTER)
	   and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,6,nil,TYPE_SPELL)
	   and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,6,nil,TYPE_TRAP)
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local dr=Duel.GetStartingHand(tp)
		local ct=dr-1
		local deck=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		--get total count of each card type
		local mnt=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER)/deck*ct
		local spl=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL)/deck*ct
		local trp=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP)/deck*ct
		--check cards to add 1 of said type 
		if mnt>spl and mnt>trp then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif spl>mnt and spl>trp then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif trp>mnt and trp>spl then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
		--if equal sends a random one to start with 2 of that type
		if mnt==spl and spl==trp then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif mnt==spl and spl~=trp then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_SPELL):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif spl==trp and mnt~=spl then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL+TYPE_TRAP):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		elseif mnt==trp and spl~=trp then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER+TYPE_TRAP):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
		--always at least 1 of each
		local g=Duel.GetDecktopGroup(tp,ct)
		local ctm=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
		local cts=g:FilterCount(Card.IsType,nil,TYPE_SPELL)
		local ctt=g:FilterCount(Card.IsType,nil,TYPE_TRAP)
		if ctm==0 then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_MONSTER):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
		if cts==0 then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_SPELL):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
		if ctt==0 then
			local g1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,TYPE_TRAP):RandomSelect(tp,1)
			local tc=g1:GetFirst()
			Duel.MoveToDeckTop(tc)
		end
	end
	e:SetLabel(1)
end
