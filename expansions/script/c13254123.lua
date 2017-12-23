--飞球高等炼金术
function c13254123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c13254123.cost)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254123,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,13254123)
	e2:SetTarget(c13254123.thtg)
	e2:SetOperation(c13254123.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254123,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,23254123)
	e3:SetCost(c13254123.thcost)
	e3:SetTarget(c13254123.thtg)
	e3:SetOperation(c13254123.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetCondition(c13073850.splimcon)
	e4:SetTarget(c13254123.sumlimit)
	c:RegisterEffect(e4)
	--draw
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(13254123,0))
	--e2:SetCategory(CATEGORY_DRAW)
	--e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1,13254123)
	--e2:SetCondition(c13254123.drcon)
	--e2:SetTarget(c13254123.drtg)
	--e2:SetOperation(c13254123.drop)
	--c:RegisterEffect(e2)
	--local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(13254123,0))
	--e3:SetCategory(CATEGORY_DRAW)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e3:SetCode(EVENT_TO_DECK)
	--e3:SetRange(LOCATION_SZONE)
	--e3:SetCountLimit(1,23254123)
	--e3:SetCondition(c13254123.drcon1)
	--e3:SetTarget(c13254123.drtg)
	--e3:SetOperation(c13254123.drop)
	--c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(13254123,ACTIVITY_SPSUMMON,c13254123.counterfilter)
	
end
function c13254123.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(13254123,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13254123.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c13254123.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c13254123.thfilter(c)
	return c:IsSetCard(0x356) and c:IsSetCard(0x46) and c:IsAbleToHand()
end
function c13254123.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254123.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c13254123.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c13254123.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c13254123.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c13254123.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x356)
end
function c13254123.gfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:GetSummonPlayer()==tp and (c:IsPreviousLocation(LOCATION_EXTRA) or c:IsSummonType(SUMMON_TYPE_FUSION))
end
function c13254123.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13254123.gfilter,1,nil,tp)
end
function c13254123.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c13254123.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c13254123.tdfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER) and c:GetReasonCard():IsType(TYPE_FUSION) and c:GetPreviousControler()==tp
end
function c13254123.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c13254123.tdfilter,1,nil,tp) 
end
