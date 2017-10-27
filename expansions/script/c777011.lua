--P.E.T.S.-Eros 孔雀式斋千惠
function c777011.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777011,4))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,777011)
	e1:SetTarget(c777011.ctltg)
	e1:SetOperation(c777011.ctlop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777011,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c777011.descon)
	e2:SetTarget(c777011.destg)
	e2:SetOperation(c777011.desop)
	c:RegisterEffect(e2)
end

c777011.is_named_with_PETS=1
function c777011.IsPETS(c)
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

function c777011.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777011.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777011.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c777011.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end

function c777011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c777011.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and c:GetFlagEffect(777011)==0
	end
	c:RegisterFlagEffect(777011,RESET_CHAIN,0,1)
end

function c777011.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c777011.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
