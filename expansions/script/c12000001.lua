--奇迹糕点 旋转餐厅
function c12000001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12000001.target)
	e1:SetOperation(c12000001.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c12000001.spcon)
	e3:SetTarget(c12000001.sptg)
	e3:SetOperation(c12000001.spop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c12000001.thtg)
	e4:SetOperation(c12000001.thop)
	c:RegisterEffect(e4)
	
end
function c12000001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c12000001.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP_DEFENSE,tp) then
		local token=Duel.CreateToken(tp,12000011)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	 end
end
function c12000001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c12000001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return (ft1+ft2)>0 and not ((ft1+ft2)>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft1+ft2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft1+ft2,0,0)
end
function c12000001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if (ft1+ft2)>0 and not ((ft1+ft2)>1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,tp) and Duel.IsPlayerCanSpecialSummonMonster(tp,12000011,0,0x4011,800,800,3,RACE_ZOMBIE,ATTRIBUTE_FIRE,POS_FACEUP,1-tp) then
		local fid=c:GetFieldID()
		for i=1,ft1 do
			local token=Duel.CreateToken(tp,12000011)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		for i=1,ft2 do
			local token=Duel.CreateToken(tp,12000011)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
end
function c12000001.thfilter(c,lv,race)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:GetRace()==race and c:IsAbleToHand() and c:IsLevelAbove(5)
end
function c12000001.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xfbe) and Duel.IsExistingMatchingCard(c12000001.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetLevel(),c:GetRace())
end
function c12000001.chkfilter(c,lv,race)
	return c:IsFaceup() and c:GetLevel()==lv
end
function c12000001.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c42000001.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(c12000001.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12000001.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function c12000001.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local lv=tc:GetLevel()
	local race=tc:GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c12000001.thfilter,tp,LOCATION_DECK,0,1,1,nil,lv,race)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
