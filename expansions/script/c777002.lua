--P.E.T.S.-Ptah 螃蟹卡布莉娜
function c777002.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777002,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,777002)
	e1:SetCondition(c777002.spcon)
	e1:SetTarget(c777002.sptg)
	e1:SetOperation(c777002.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777002,4))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,777102)
	e2:SetTarget(c777002.ctltg)
	e2:SetOperation(c777002.ctlop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--tuner
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(777002,5))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCost(c777002.tdcost)
	e4:SetTarget(c777002.tdtg)
	e4:SetOperation(c777002.tdop)
	c:RegisterEffect(e4)
end

c777002.is_named_with_PETS=1
function c777002.IsPETS(c)
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
	return mt and mt.is_named_with_PETS
end


function c777002.cfilter(c)
	return c:IsFaceup() and c777002.IsPETS(c)
end

function c777002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c777002.cfilter,tp,0,LOCATION_MZONE,1,nil) 
end

function c777002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMZoneCount(tp)>0 or Duel.GetMZoneCount(1-tp)>0)
		and (e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) or e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c777002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local s1=Duel.GetMZoneCount(tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetMZoneCount(1-tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777002,1),aux.Stringid(777002,2))
	elseif s1 and not s2 then op=Duel.SelectOption(tp,aux.Stringid(777002,1))
	elseif not s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777002,2))+1
	elseif not s1 and not s2 then return end
	if op==0 then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	else Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) end 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1,true)
end


function c777002.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777002.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777002.tdfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) 
end

function c777002.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c777002.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c777002.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c777002.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c777002.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c777002.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end