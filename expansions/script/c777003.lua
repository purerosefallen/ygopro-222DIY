--P.E.T.S.-Eros 金鱼姬亚美
function c777003.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,777003)
	e1:SetCondition(c777003.spcon)
	e1:SetTarget(c777003.sptg)
	e1:SetOperation(c777003.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777003,4))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,777103)
	e2:SetTarget(c777003.ctltg)
	e2:SetOperation(c777003.ctlop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spellcard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(777003,5))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCost(c777003.tdcost)
	e4:SetTarget(c777003.tdtg)
	e4:SetOperation(c777003.tdop)
	c:RegisterEffect(e4)
end

c777003.is_named_with_PETS=1
function c777003.IsPETS(c)
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


function c777003.cfilter(c)
	return c:IsFaceup() and c777003.IsPETS(c)
end

function c777003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c777003.cfilter,tp,0,LOCATION_MZONE,1,nil) 
end

function c777003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMZoneCount(tp)>0 or Duel.GetMZoneCount(1-tp)>0)
		and (e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) or e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c777003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local s1=Duel.GetMZoneCount(tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetMZoneCount(1-tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777003,1),aux.Stringid(777003,2))
	elseif s1 and not s2 then op=Duel.SelectOption(tp,aux.Stringid(777003,1))
	elseif not s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777003,2))+1
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


function c777003.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777003.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777003.tdfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c777003.IsPETS(c)
end

function c777003.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c777003.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c777003.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c777003.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c777003.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c777003.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
