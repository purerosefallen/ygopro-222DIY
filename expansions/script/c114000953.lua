--★時を遡る魔法少女 暁美ほむら
function c114000953.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114000953.condition)
	e1:SetTarget(c114000953.target)
	e1:SetOperation(c114000953.operation)
	c:RegisterEffect(e1)
	--count
	if not c114000953.global_check then
		c114000953.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c114000953.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_REMOVE)
		ge2:SetOperation(c114000953.checkop)
		Duel.RegisterEffect(ge2,0)		
	end
	--return to deck + draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c114000953.retcon)
	e2:SetOperation(c114000953.retop)
	c:RegisterEffect(e2)
	--addcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_CODE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE+LOCATION_ONFIELD)
	e3:SetValue(114000965)
	c:RegisterEffect(e3)
end
function c114000953.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) and tc:IsSetCard(0xcabb) then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,114000953,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,114000953,RESET_PHASE+PHASE_END,0,1) end
end
function c114000953.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,114000953)~=0
end
function c114000953.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c114000953.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end

function c114000953.retcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re 
	and ( rc:IsSetCard(0xcabb) or rc:IsSetCard(0x223) or rc:IsSetCard(0x224) or rc:IsSetCard(0x5047)
	or rc:IsCode(36405256) or rc:IsCode(54360049) or rc:IsCode(37160778) or rc:IsCode(27491571) or rc:IsCode(80741828) or rc:IsCode(90330453) --0x223
	or rc:IsCode(32751480) or rc:IsCode(78010363) or rc:IsCode(39432962) or rc:IsCode(67511500) or rc:IsCode(62379337) or rc:IsCode(23087070) or rc:IsCode(17720747) or rc:IsCode(98358303) or rc:IsCode(91584698) ) --0x224
	and e:GetHandler():GetSummonType()~=SUMMON_TYPE_PENDULUM
end

function c114000953.filter(c,tid)
	return c:IsType(TYPE_MONSTER) and c:GetTurnID()==tid and c:IsAbleToDeck()
end
function c114000953.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--return to deck
	local tid=Duel.GetTurnCount()
	local sg=Duel.GetMatchingGroup(c114000953.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,tid)
	if sg:GetCount()==0 then return end
	Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		local dg=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
		if dg>0 then
			Duel.ShuffleDeck(tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end