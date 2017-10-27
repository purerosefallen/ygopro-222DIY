--圣遗物-疾风锁镰
function c710239.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c710239.target)
	e1:SetOperation(c710239.operation)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	--Double Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--equip 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c710239.eqcon1)
	e4:SetTarget(c710239.eqtg)
	e4:SetOperation(c710239.eqop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c710239.eqcon2)
	e5:SetTarget(c710239.eqtg)
	e5:SetOperation(c710239.eqop)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,710239)
	e6:SetCondition(c710239.spcon)
	e6:SetTarget(c710239.sptg)
	e6:SetOperation(c710239.spop)
	c:RegisterEffect(e6)
	--Equip limit
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_EQUIP_LIMIT)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e8)
end

c710239.is_named_with_Relic=1
function c710239.IsRelic(c)
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

function c710239.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c710239.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function c710239.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c710239.eqcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c710239.eqfilter(c,ec)
	return c:IsType(TYPE_EQUIP) and c710239.IsRelic(c) and 
		c:CheckEquipTarget(ec)
end
function c710239.eqfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and 
		Duel.IsExistingMatchingCard(c710239.eqfilter,tp,LOCATION_HAND,0,1,nil,c) 
end
function c710239.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c710239.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c) 
		and e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND)
end
function c710239.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local h=Duel.SelectMatchingCard(tp,c710239.eqfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(710239,1))
	local g=Duel.SelectMatchingCard(tp,c710239.eqfilter,tp,LOCATION_HAND,0,1,1,nil,h:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	tc=g:GetFirst()
	Duel.Equip(tp,tc,h:GetFirst())
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)  
end

function c710239.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c710239.spfilter(c)
	return c710239.IsRelic(c) 
end
function c710239.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,710239,c710239.spfilter,0x1011,0,2400,5,RACE_WARRIOR,ATTRIBUTE_WIND) 
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c710239.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,710239,c710239.spfilter,0x1011,0,2400,5,RACE_WARRIOR,ATTRIBUTE_WIND) then
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
		Duel.SpecialSummonComplete()
	end
end

function c710239.acon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandlerPlayer()==e:GetLabel()
end