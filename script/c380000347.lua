--Go, Gradius!
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
end
s.listed_names={10992251,54289683,14291024,5494820,93130021,10642488}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local b1=(Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,54289683) and Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_MZONE,0,1,nil))
	local b2=(Duel.IsExistingMatchingCard(s.namefilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1)
	--condition
	return aux.CanActivateSkill(tp) and (b1 or b2)
end
s.namefilter=aux.FilterFaceupFunction(Card.IsCode,10992251)
s.namefilter2=aux.FilterFaceupFunction(Card.IsOriginalCodeRule,10992251)
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local b1=(Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,54289683) and Duel.IsExistingMatchingCard(s.namefilter,tp,LOCATION_MZONE,0,1,nil))
	local b2=(Duel.IsExistingMatchingCard(s.namefilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1)
	local opt=0
	if b1 and b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif b2 then
		opt=Duel.SelectOption(tp,aux.Stringid(id,2))+1
	else return end
	local g=nil
	local sg=nil
	if opt==0 then
		g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,54289683)
		local tc=g:GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,tc)
			local cards={14291024,5494820}
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
			local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards))
			tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
			Duel.ConfirmCards(1-tp,tc)
			Duel.ShuffleHand(tp)
		end
	else
		sg=Duel.SelectMatchingCard(tp,s.namefilter2,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc then
			local cards={93130021,10642488}
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
			local code=Duel.SelectCardsFromCodes(tp,1,1,nil,false,table.unpack(cards))
			tc:Recreate(code,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,true)
		end
	end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(2<<32))
end
