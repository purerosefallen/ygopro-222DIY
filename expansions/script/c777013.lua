--P.E.T.S.-Thoth 熊猫林莉
function c777013.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c777013.fscon)
	e1:SetOperation(c777013.fsop)
	c:RegisterEffect(e1)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(777013,4))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,777013)
	e1:SetTarget(c777013.ctltg)
	e1:SetOperation(c777013.ctlop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(777013,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c777013.descon)
	e2:SetTarget(c777013.destg)
	e2:SetOperation(c777013.desop)
	c:RegisterEffect(e2)
end

c777013.is_named_with_PETS=1
function c777013.IsPETS(c)
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


function c777013.ffilter_base(c,fc)
	return c:GetFusionAttribute()~=0 and c:IsCanBeFusionMaterial(fc)
end
function c777013.ffilter(c,fc,mg,attr)
	if not c:IsType(TYPE_MONSTER) or c:GetAttribute()==0 then return false end
	if not c:IsCanBeFusionMaterial(fc) then return false end
	if attr then
		return not c:IsAttribute(attr)
	else
		return mg:FilterCount(c777013.ffilter,c,fc,mg,c:GetAttribute())>0
	end
end
function c777013.fscon(e,g,gc,chkf)
	if g==nil then return true end
	local mg=g:Filter(c777013.ffilter_base,nil,e:GetHandler())
	if gc then
		mg:AddCard(gc)
		return c777013.ffilter_base(gc,e:GetHandler()) and mg:FilterCount(c777013.ffilter,nil,e:GetHandler(),mg)>0
	end
	local fs=false
	if mg:IsExists(aux.FConditionCheckF,1,nil,chkf) then fs=true end
	return mg:FilterCount(c777013.ffilter,nil,e:GetHandler(),mg)>0 and (fs or chkf==PLAYER_NONE)
end
function c777013.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local sg=eg:Filter(c777013.ffilter_base,gc,e:GetHandler())
	if gc then
		sg:Remove(Card.IsFusionAttribute,nil,gc:GetFusionAttribute())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else
		g1=sg:Select(tp,1,1,nil)
	end
	sg:Remove(Card.IsFusionAttribute,nil,g1:GetFirst():GetFusionAttribute())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SetFusionMaterial(g1)
end


function c777013.ctltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) end
	if chk==0 then return e:GetHandler():IsControlerCanBeChanged() end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end

function c777013.ctlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.GetControl(c,1-tp)
	end
end


function c777013.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c)
end

function c777013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(777013)==0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
	c:RegisterFlagEffect(777013,RESET_CHAIN,0,1)
end

function c777013.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)<2 then return end
	if Duel.DiscardHand(1-tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD,nil)>0 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end

