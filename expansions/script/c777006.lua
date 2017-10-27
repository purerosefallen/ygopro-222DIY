--P.E.T.S.-Thoth 企鹅亚莉
function c777006.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,777006)
	e1:SetCondition(c777006.spcon)
	e1:SetTarget(c777006.sptg)
	e1:SetOperation(c777006.spop)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777006,4))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,777106)
	e2:SetTarget(c777006.ctltg)
	e2:SetOperation(c777006.ctlop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--RACE
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(777006,5))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCost(c777006.tdcost)
	e4:SetTarget(c777006.tdtg)
	e4:SetOperation(c777006.tdop)
	c:RegisterEffect(e4)
end

c777006.is_named_with_PETS=1
function c777006.IsPETS(c)
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


function c777006.cfilter(c)
	return c:IsFaceup() and c777006.IsPETS(c)
end

function c777006.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and Duel.IsExistingMatchingCard(c777006.cfilter,tp,0,LOCATION_MZONE,1,nil) 
end

function c777006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetMZoneCount(tp)>0 or Duel.GetMZoneCount(1-tp)>0)
		and (e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) or e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c777006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local s1=Duel.GetMZoneCount(tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetMZoneCount(1-tp)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,0)
	if s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777006,1),aux.Stringid(777006,2))
	elseif s1 and not s2 then op=Duel.SelectOption(tp,aux.Stringid(777006,1))
	elseif not s1 and s2 then op=Duel.SelectOption(tp,aux.Stringid(777006,2))+1
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


function c777006.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777006.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777006.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function c777006.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c777006.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c777006.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c777006.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c777006.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,562)
	local rc=Duel.AnnounceAttribute(tp,1,0xff-g:GetFirst():GetAttribute())
	e:SetLabel(rc)
end

function c777006.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel())
		tc:RegisterEffect(e1)
	end
end
