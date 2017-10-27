--圣遗物-支配之镰
function c710236.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c710236.target)
	e1:SetOperation(c710236.operation)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c710236.efilter)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	--equip 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c710236.eqcon1)
	e4:SetTarget(c710236.eqtg)
	e4:SetOperation(c710236.eqop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c710236.eqcon2)
	e5:SetTarget(c710236.eqtg)
	e5:SetOperation(c710236.eqop)
	c:RegisterEffect(e5)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,710236)
	e6:SetTarget(c710236.sptg)
	e6:SetOperation(c710236.spop)
	c:RegisterEffect(e6)
	--Equip limit
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EQUIP_LIMIT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
end

c710236.is_named_with_Relic=1
function c710236.IsRelic(c)
	local code=c:GetCode()
	local mt=_G["c"..code]
	if not mt then
		_G["c"..code]={}
		if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
			mt=_G["c"..code]
			_G["c"..code]=nil
		else
			_G["c"..code]=nil
			return false
		end
	end
	return mt and mt.is_named_with_Relic
end

function c710236.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c710236.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function c710236.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c710236.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c710236.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c710236.eqfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and c710236.IsRelic(c) and 
		c:CheckEquipTarget(ec)
end
function c710236.eqfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and 
		Duel.IsExistingMatchingCard(c710236.eqfilter,tp,LOCATION_HAND,0,1,nil,c) 
end
function c710236.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c710236.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) 
		and e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c710236.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local h=Duel.SelectMatchingCard(tp,c710236.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(710236,1))
	local g=Duel.SelectMatchingCard(tp,c710236.eqfilter,tp,LOCATION_HAND,0,1,1,nil,h:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	tc=g:GetFirst()
	Duel.Equip(tp,tc,h:GetFirst())
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

function c710236.spfilter(c)
	return c710236.IsRelic(c) 
end
function c710236.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,710236,c710236.spfilter,0x1001,0,0,3,RACE_WARRIOR,ATTRIBUTE_DARK) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c710236.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,710236,c710236.spfilter,0x1011,0,0,3,RACE_WARRIOR,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TUNER)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		--redirect
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECK)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e2:SetValue(1)
		c:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end