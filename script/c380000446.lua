--Memories of a Pharaoh: Obelisk the Tormentor
local s,id=GetID()
function s.initial_effect(c)
	--skill
	aux.AddPreDrawSkillProcedure(c,1,false,s.flipcon,s.flipop)
end
s.listed_names={10000000,CARD_BLUEEYES_W_DRAGON}
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(ep,id)>0 then return end
	--condition
	return Duel.GetCurrentChain()==0 and Duel.IsTurnPlayer(tp)
	and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
	and Duel.GetDrawCount(tp)>0
	and Duel.GetTurnCount()>=5
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(ep,id,0,0,0)
	--draw "Obelisk the Tormentor"
	local token=Duel.CreateToken(tp,10000002)
	Duel.SendtoDeck(token,nil,SEQ_DECKTOP,REASON_RULE)
	--triple tribute
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRIPLE_TRIBUTE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(s.tttg)
	e1:SetValue(s.ttcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--send to Graveyard if you Tribute 1 "Blue-Eyes White Dragon"
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(s.checkop)
	Duel.RegisterEffect(e2,tp)
end
function s.tttg(e,c)
	return c:IsOriginalCodeRule(CARD_BLUEEYES_W_DRAGON) and (c:IsControler(e:GetHandlerPlayer() or c:IsFaceup()))
end
function s.ttcon(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsCode(10000000) and Duel.GetFlagEffect(e:GetHandlerPlayer(),id+1)==0
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local g=tc:GetMaterial()
	if tc:IsSummonType(SUMMON_TYPE_TRIBUTE) and tc:IsCode(10000000) and g:IsExists(Card.IsOriginalCode,1,nil,CARD_BLUEEYES_W_DRAGON) then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(ep,id+1,0,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCondition(s.tgcon)
		e1:SetOperation(s.tgop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(id)>0
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_RULE)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then
		Duel.SendtoGrave(e:GetLabelObject(),REASON_RULE)
	end
end
