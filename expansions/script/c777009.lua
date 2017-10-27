--P.E.T.S.-Ptah 黑熊安娜
function c777009.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777009,4))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,777009)
	e1:SetTarget(c777009.ctltg)
	e1:SetOperation(c777009.ctlop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777009,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c777009.descon)
	e2:SetTarget(c777009.destg)
	e2:SetOperation(c777009.desop)
	c:RegisterEffect(e2)
end

c777009.is_named_with_PETS=1
function c777009.IsPETS(c)
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

function c777009.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777009.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777009.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetSequence()<5
end
function c777009.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c777009.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end

function c777009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c777009.desfilter(chkc) end
	if chk==0 then
		if Duel.IsExistingMatchingCard(c777009.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then return true end
		if c:GetFlagEffect(777009)~=0 then return false end
		local ft=Duel.GetMZoneCount(1-tp)
		if ft<0 then return false
		elseif ft>0 then
			return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil)
		else
			return Duel.IsExistingTarget(c777009.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
		end
	end
	local ft=Duel.GetMZoneCount(1-tp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft>0 then
		g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	else
		g=Duel.SelectTarget(tp,c777009.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	c:RegisterFlagEffect(777009,RESET_CHAIN,0,1)
end

function c777009.desop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=tg:GetFirst()
	if tc then
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			if Duel.GetMZoneCount(tp)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c777009.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				if Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE)>0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+0x47e0000)
					e1:SetValue(LOCATION_REMOVED)
					g:RegisterEffect(e1,true)
				end 
			end
		end
	end
end
