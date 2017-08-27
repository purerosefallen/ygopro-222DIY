--骸龙剑
function c10173013.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10173013)
	e1:SetCondition(c10173013.spcon)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(10173013,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,10173113)
	e2:SetCost(c10173013.thcost)
	e2:SetTarget(c10173013.thtg)
	e2:SetOperation(c10173013.thop)
	c:RegisterEffect(e2)
	--return
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173013,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,10173213)
	e3:SetOperation(c10173013.tgop)
	c:RegisterEffect(e3)
	if not c10173013.global_check then
		c10173013.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetOperation(c10173013.checkop)
		Duel.RegisterEffect(ge1,0)
	end   
end
function c10173013.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_RETURN)
	end
end
function c10173013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c10173013.thfilter(c,tp)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_SZONE) and c:IsControler(tp) and c:IsAbleToHand()
end
function c10173013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10173013.thfilter,1,nil,tp) end
	local g=eg:Filter(c10173013.thfilter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10173013.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10173013.thfilter2,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c10173013.thfilter2(c,e)
	return c:IsRelateToEffect(e) and bit.band(c:GetType(),0x40002)==0x40002
end
function c10173013.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.GetFlagEffect(0,10173013)>0
end
function c10173013.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c10173013.cfilter,1,nil) then
	   Duel.RegisterFlagEffect(0,10173013,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	end
end
function c10173013.cfilter(c)
	return bit.band(c:GetType(),0x40002)==0x40002 and c:IsFaceup()
end