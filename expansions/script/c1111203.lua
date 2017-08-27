--灵都·雾雨綿都
function c1111203.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c1111203.tg2)
	e2:SetValue(c1111203.vfilter2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,1111203) 
	e3:SetCondition(c1111203.con3)
	e3:SetTarget(c1111203.tg3)
	e3:SetOperation(c1111203.op3)
	c:RegisterEffect(e3)
--
end
--
c1111203.named_with_Ld=1
function c1111203.IsLd(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Ld
end
--
function c1111203.vfilter2(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP))
end
--
function c1111203.tfilter2(c)
	return c:IsFaceup() and c1111203.IsLd(c) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c1111203.tg2(e,c)
	local g=Duel.GetMatchingGroup(c1111203.tfilter2,c:GetControler(),LOCATION_MZONE,0,nil)
	return g
end
--
function c1111203.cfilter3(c)
	return c1111203.IsLd(c)
end
function c1111203.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1111203.cfilter3,1,nil)
end
--
function c1111203.tfilter3(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and (c:IsRace(RACE_FAIRY) or c:IsRace(RACE_PSYCHO)) and c:GetLevel()<4
end
function c1111203.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1111203.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1111203.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1111203.tfilter3,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--